module Dossier
  class Segment
    class Rows
      include Enumerable
      attr_accessor :segmenter, :segment, :report, :definition

      def initialize(segmenter, segment, definition)
        self.segmenter  = segmenter
        self.report     = segmenter.report
        self.segment    = segment
        self.definition = definition
        @key_parts      = []
      end

      def each
        rows.each { |row| yield row }
      end

      delegate :length, :count, :empty?, to: :rows

      private

      def rows
        @rows ||= segmenter.data.fetch(segment.key_path)
      end
    end
  end
end
