require 'spec_helper'

describe Dossier::Segment::Definition do
  let(:report_class)    { Class.new(Dossier::Report) }
  let(:segmenter_class) { report_class.segmenter_class }
  let(:definition)      { described_class.new(segmenter_class, :foo) }

  describe "attributes" do
    it "has a segmenter_class" do
      expect(definition.segmenter_class).to eq segmenter_class
    end
    it "has a name" do
      expect(definition.name).to eq :foo
    end

    it "uses the name as the group by if one isn't provided" do
      expect(definition.group_by).to eq :foo
    end

    it "uses the name as the display name if one isn't provided" do
      expect(definition.display_name).to eq :foo
    end

    it "has a group_by" do
      definition = described_class.new(segmenter_class, :foo, group_by: :bar)
      expect(definition.group_by).to eq :bar
    end

    it "has a display_name" do
      definition = described_class.new(segmenter_class, :foo, display_name: :baz)
      expect(definition.display_name).to eq :baz
    end

    it "has a segment class name" do
      expect(definition.segment_class_name).to eq 'Foo'
    end

    it "has a plural name" do
      expect(definition.plural_name).to eq 'foos'
    end

    describe "for columns" do
      it "knows to use the name" do
        definition = described_class.new(segmenter_class, :foo)
        expect(definition.columns).to eq %w[foo]
      end

      it "knows to use group_by if provided" do
        definition = described_class.new(segmenter_class, :foo, group_by: :bar)
        expect(definition.columns).to eq %w[bar foo]
      end

      it "knows to use display_name if not a proc" do
        definition = described_class.new(segmenter_class, :foo, display_name: :baz)
        expect(definition.columns).to eq %w[foo baz]
      end

      it "knows not to use display_name if not a proc" do
        definition = described_class.new(segmenter_class, :foo, display_name: ->(row) {})
        expect(definition.columns).to eq %w[foo]
      end

      it "knows not to use the name if group_by and display_name are set" do
        definition = described_class.new(segmenter_class, :foo, group_by: :bar, display_name: :baz)
        expect(definition.columns).to eq %w[bar baz]
      end
    end
  end

  describe "segment subclass" do
    it "is defined in the report class namespace as a subclass of Dossier::Segment" do
      expect(definition.segment_subclass.superclass).to eq Dossier::Segment
    end

    it "sets up the segment subclasses name constant properly" do
      d = Dossier::Segment::Definition.new(TestReport.segmenter_class, :foo)
      expect(TestReport::Foo).to be_a Class
    end
  end
end
