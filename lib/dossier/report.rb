module Dossier
  class Report
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
      self.options = options
    end

    private

    def self.dsl(type, string = nil, block = nil)
      instance_variable_set(:"@#{type}", block || string)
    end

    def compile(type)
      sql_fragment = self.class.instance_variable_get(:"@#{type}")
      sql_fragment = instance_eval(&sql_fragment) if sql_fragment.respond_to?(:call)
      @conditions  = nil
      sql_fragment.to_s
    end
    
    def conditions
      @conditions ||= ConditionSet.new
    end

  end
end
