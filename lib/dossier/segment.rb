module Dossier
  class Segment
    attr_accessor :segmenter, :report, :definition, :parent, :options

    def initialize(segmenter, definition, options = {})
      self.segmenter  = segmenter
      self.report     = segmenter.report
      self.definition = definition
      self.options    = options
      extend(definition.chain_module)
    end

    def display_name
      if definition.display_name.respond_to?(:call)
        definition.display_name.call(options)
      else
        options.fetch(definition.display_name)
      end
    end
    
    def group_by
      options.fetch(definition.group_by)
    end

    def chain
      parent_chain(self)
      @chain
    end

    def key_path
      chain.map(&:group_by).reverse.join('.')
    end

    private

    def parent_chain(segment)
      @chain ||= []
      if segment.parent
        @chain << segment.parent
        parent_chain(segment)
      end
    end

  end
end
