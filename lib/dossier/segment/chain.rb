module Dossier
  class Segment
    class Chain
      include Enumerable

      def initialize
        @segment_chain = []
      end

      def at(index)
        segment_chain.at(index)
      end
      alias :[] :at

      def <<(segment)
        last.next    = segment unless last.nil?
        segment.prev = last    unless last.nil?
        segment_chain << segment
      end

      def each
        segment_chain.each { |segment| yield segment }
      end

      delegate :first, :last, :length, :empty?, to: "@segment_chain"

      private
      attr_reader :segment_chain
    end
  end
end
