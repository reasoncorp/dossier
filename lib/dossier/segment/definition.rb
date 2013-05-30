module Dossier
  class Segment
    class Definition
      attr_accessor :segmenter_class, :report_class, :name, :group_by, :display_name, :next, :prev
      attr_reader :segment_subclass

      def initialize(segmenter_class, name, options = {})
        self.segmenter_class = segmenter_class
        self.report_class    = segmenter_class.report_class
        self.name            = name
        self.group_by        = options.fetch(:group_by, name)
        self.display_name    = options.fetch(:display_name, name)
        define_segment_subclass
      end

      def segment_class_name
        name.to_s.classify
      end

      def plural_name
        name.to_s.pluralize
      end

      def columns
        [group_by, display_name_for_column].map(&:to_s).uniq
      end

      def next?
        !!self.next
      end

      def prev?
        !!prev
      end

      def chain_module
        next? ? self.next.segment_module : rows_module
      end

      def segment_module
        definition = self
        Module.new do
          define_method definition.plural_name do
            @segments ||= segmenter.segment_options_for(self).map { |options| 
              definition.segment_subclass.new(segmenter, definition, options).tap do |instance|
                instance.parent = self if is_a?(Dossier::Segment)
              end
            }
          end
        end
      end

      private

      def define_segment_subclass
        @segment_subclass = report_class.const_set(segment_class_name, Class.new(Dossier::Segment))
      end

      def display_name_for_column
        display_name.respond_to?(:call) ? name : display_name
      end

      def rows_module
        definition = self
        Module.new do
          define_method :rows do
            @rows ||= Rows.new(segmenter, self, definition)
          end
        end
      end
    end
  end
end
