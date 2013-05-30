require 'spec_helper'

describe Dossier::Segment do

  let(:report_class)     { Class.new(Dossier::Report) }
  let!(:segmenter_class) { 
    report_class.segmenter_class.tap { |sc|
      sc.segment :foo
    }
  }
  let(:definition)      { segmenter_class.segments.first }
  let(:report)          { report_class.new }
  let(:segmenter)       { report.segmenter }
  let(:segment)         { described_class.new(segmenter, definition) }

  describe "attributes" do
    it "takes the segment instance" do
      expect(segment.segmenter).to eq segmenter
    end

    it "takes its definition" do
      expect(segment.definition).to eq definition
    end

    it "has access to the report" do
      expect(segment.report).to eq report
    end
  end

end
