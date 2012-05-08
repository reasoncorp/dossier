module Dossier
  class Report

    SELECT = 'SELECT'
    WHERE  = 'WHERE'
    HAVING = 'HAVING'
    ORDER  = 'ORDER BY'
    
    attr_accessor :options

    %w[select where having order].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{method}(string = nil, &block)
          dsl :#{method}, string, block
        end

        def #{method}
          compile :#{method}
        end
      RUBY
    end

    def initialize(options = {})
      self.options = options.with_indifferent_access
    end

    def sql
      "#{select} #{where} #{having} #{order}".strip
    end

    private

    def self.dsl(type, string = nil, block = nil)
      instance_variable_set(:"@#{type}", block || string)
    end

    def compile(type)
      @conditions  = nil
      sql_fragment = self.class.instance_variable_get(:"@#{type}")
      sql_fragment = instance_eval(&sql_fragment).to_s if sql_fragment.respond_to?(:call)
      return if sql_fragment.blank?
      "#{self.class.const_get(type.to_s.upcase)} #{sql_fragment}"
    end
    
    def conditions
      @conditions ||= ConditionSet.new
    end

    def fragment(sql, binds)
      Condition.new(sql, binds)
    end

  end
end
