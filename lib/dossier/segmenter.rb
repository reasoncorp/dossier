module Dossier
  class Segmenter
    attr_accessor :report

    class << self
      attr_accessor :report_class
    end

    def self.segments
      @segment_chain ||= Segment::Chain.new
    end

    def self.segment(name, options = {}, &block)
      segments << Segment::Definition.new(self, name, options)
      instance_eval(&block) if block_given?
    end

    def self.skip_headers
      segments.map(&:columns).flatten
    end
    delegate :skip_headers, to: "self.class"
    
    def initialize(report)
      self.report = report
      extend(segment_chain.first.segment_module)
    end

    def headers
      @headers ||= report.results.headers.reject { |header| header.in?(skip_headers) }
    end

    def data
      @data ||= report.results.rows.inject(Hash.new { [] }) { |acc, row|
        acc.tap { |hash| hash[key_path_for(row)] += [row] }
      }
    end

    def segment_chain
      self.class.segments
    end

    def segmenter
      self
    end

    def segment_options_for(segment)
      data.keys.select { |k, v| k.match segment.key_path }.
        map { |key| data[key].first }.
        flatten.map { |row| Hash[report.results.headers.zip(row)] }
    end

    private

    def key_path_for(row)
      group_by_indexes.map { |i| row.at(i) }.join('.')
    end

    def segment_options
      data unless defined?(@data)
      @segment_options
    end

    def header_index_map
      @header_index_map ||= Hash[skip_headers.map { |h| [h, report.results.headers.index(h)] }]
    end

    def group_by_indexes
      @group_by_indexes ||= header_index_map.values_at(*segment_chain.map(&:group_by).map(&:to_s))
    end
  end
end
