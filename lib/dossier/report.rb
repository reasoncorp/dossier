module Dossier
  class Report

    attr_accessor :options
    attr_reader :results

    def self.options
      @options ||= {}
    end

    def self.option(name, options)
      self.options[name] = options.delete(:default)
    end

    def self.keyword(type)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{type}(string = nil, &block)
          clause :#{type}, string, block
        end

        def #{type}
          clause :#{type}
        end
      RUBY
    end

    keyword :before
    keyword :query
    keyword :select
    keyword :where
    keyword :having
    keyword :group_by
    keyword :order_by
    keyword :after

    def self.format(formats)
      @formats = formats.inject({}) do |hash, (key, format)|
        hash[key] = lookup_format_class(format)
        hash
      end.with_indifferent_access
    end

    def initialize(options = {})
      self.options = self.class.options.merge(options).with_indifferent_access
    end

    def sql
      before
      query.presence || "#{select} #{where} #{having} #{group_by} #{order_by}".strip
    end
    
    def run
      @results = Results.new(Dossier.client.query(sql), self)
      after
      self
    rescue Mysql2::Error => e
      raise Mysql2::Error.new("#{e.message}. \n\n #{sql}")
    end

    def headers
      results.headers.map {|key| Dossier::Format::Title.new(key)}
    end

    def rows
      results.map(&:values)
    end

    def to_a
      [headers] + rows.map {|row| row.map(&:value)}
    end

    def view
      self.class.name.sub('Report', '').downcase
    end

    # For the benefit of the `format` method. See also `lookup_format_class`.
    # Assume missing format constants are in the Dossier::Format namespace.
    # Eg: `format :salary => Currency` will look for Dossier::Format::Currency
    # before exploding.
    def self.const_missing(name)
      return Dossier::Format.const_get(name) if Dossier::Format.const_defined?(name)
      super
    end

    private

    def self.formats
      @formats ||= {}
    end

    # For the benefit of the `format` method. See also `self.const_missing`.
    # Ensure that, even if const_missing isn't called, we find format
    # constants under Dossier::Format if they exist.
    # Eg: `format :salary => Date`; Date is an existing constant, but we want
    # Dossier::Format::Date. If that doesn't exist, use ::Date.
    def self.lookup_format_class(format)
      # Any namespaced constant clearly isn't under Dossier::Format
      return format if format.name =~ /::/ 

      Dossier::Format.const_get(format.name)
    end

    # Class method sets the clause
    def self.clause(type, string = nil, block = nil)
      instance_variable_set(:"@#{type}", block || string)
    end

    # Instance method gets the clause
    def clause(type)
      @conditions  = nil
      sql_fragment = self.class.instance_variable_get(:"@#{type}")
      sql_fragment = instance_eval(&sql_fragment).to_s if sql_fragment.respond_to?(:call)
      return if sql_fragment.blank?
      keyword = type == :query ? nil : type.to_s.gsub('_', ' ').upcase
      "#{keyword} #{sql_fragment}".strip
    end
    
    def conditions
      @conditions ||= ConditionSet.new
    end

    def condition(sql, binds)
      Condition.new(sql, binds)
    end

  end
end
