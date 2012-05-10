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

    keyword :select
    keyword :where
    keyword :having
    keyword :group_by
    keyword :order_by

    def initialize(options = {})
      self.options = self.class.options.merge(options).with_indifferent_access
    end

    def sql
      "#{select} #{where} #{having} #{group_by} #{order_by}".strip
    end
    
    def run
      @results = Dossier.client.query(sql)
    rescue Mysql2::Error => e
      raise Mysql2::Error.new("#{e.message}. \n\n #{sql}")
    end

    def view
      self.class.name.sub('Report', '').downcase
    end

    private

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
      "#{type.to_s.gsub('_', ' ').upcase} #{sql_fragment}"
    end
    
    def conditions
      @conditions ||= ConditionSet.new
    end

    def condition(sql, binds)
      Condition.new(sql, binds)
    end

  end
end
