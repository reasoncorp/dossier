module Dossier
  class Segmenter
    attr_accessor :report

    delegate :segments, to: "self.class"

    def self.segments
      @segments ||= SegmentChain.new
    end

    def self.segment(group_by, options = {}, &block)
      segments << SegmentDefinition.new(self, group_by, options.fetch(:display_name, group_by))
      instance_eval(&block) if block_given?
    end
    
    def initialize(report)
      self.report = report
      segment_definitions.first.connect(self)
    end

    def data
      @data ||= report.results.rows.inject(default_data) { |acc, row|
        acc.tap do |hash|
        end
      }
    end

    def default_data
      segment_definitions.map(&:group_by).reduce({}) do |acc, group_by|
        acc.tap { |hash| hash[group_by] = {} }
      end
    end
    
    def segment_definitions
      self.class.segments
    end
    
    def segments
      @segments ||= segment_definitions.map { |definition| definition.segment_class.new(self, definition) }
    end
  end

  class SegmentChain
    include Enumerable

    def initialize
      @segment_chain = []
    end

    def at(index)
      segment_chain.at(index)
    end
    alias :[] :at

    def <<(segment)
      segment_chain.last.connect(segment) if segment_chain.any?
      segment_chain << segment
    end

    def each
      segment_chain.each { |segment| yield segment }
    end

    private
    attr_reader :segment_chain
  end

  class SegmentDefinition
    attr_accessor :segmenter, :group_by, :display_name, :parent, :child

    def initialize(segmenter, group_by, display_name)
      self.segmenter    = segmenter
      self.group_by     = group_by
      self.display_name = display_name
      define_segment_class
    end

    def connect(segment)
      self.parent = segment
      segment.extend proxy_module
    end

    def proxy_module
      segment = self
      Module.new do
        define_method(segment.link_method) do
        end
      end
    end

    def link_method
      group_by.to_s.pluralize
    end

    def segment_class_name
      group_by.to_s.classify
    end

    def segment_class
      segmenter.const_get(segment_class_name)
    end

    private

    def define_segment_class
      segmenter.const_set(segment_class_name, Class.new(Segment))
    end
  end

  class Segment
    attr_accessor :segmenter, :report, :definition

    def initialize(segmenter, definition)
      self.segmenter  = segmenter
      self.report     = segmenter.report
      self.definition = definition
    end
  end
end
