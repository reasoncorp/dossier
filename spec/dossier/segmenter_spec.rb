require 'spec_helper'

describe Dossier::Segmenter do

  let(:segmenter_class) {
    Class.new(Dossier::Segmenter) {
      segment :s1
      segment :s2, display_name: :s2_name do
        segment :s3, display_name: ->(row) { "#{row[:s1]} - #{row[:s3]}" }
      end
    }
  }
  let(:report)    { Class.new(Dossier::Report).new }
  let(:segmenter) { segmenter_class.new(report) }

  describe "report data" do
    it "stores the report rows in a hash organized by segment" do
      expect(segmenter.data).to eq({s1: {s2: {s3: []}}})
    end
  end

  describe "segments" do
    let(:segmenter) { segmenter_class }

    it "keeps an array of segments" do
      expect(segmenter.segments.count).to eq 3
    end

    it "keeps the segments in the order defined" do
      expect(segmenter.segments[1].group_by).to eq :s2
    end

    it "allows nesting segment definations" do
      expect(segmenter.segments[2].group_by).to eq :s3
    end

    describe "display_name" do
      it "allows passing a symbol" do
        expect(segmenter.segments[1].display_name).to eq :s2_name
      end

      it "allows passing a proc" do
        expect(segmenter.segments[2].display_name).to be_a(Proc)
      end
    end
  end

  describe "segment chain" do
    describe "base" do
      it "takes the report upon instantiation" do
        expect(segmenter.report).to eq report
      end

      it "has access to its classes segments" do
        expect(segmenter.segments).to eq segmenter.class.segments
      end

      it "will have an s1s" do
        expect(segmenter).to respond_to(:s1s)
      end
    end 

    describe "s1s" do
      it "will have an s2s" do
        expect(segmenter.s1s.first).to respond_to(:s2s)
      end
    end

    describe "s2s" do
      it "will have an s3s" do
        expect(segmenter.s2s.first).to respond_to(:s3s)
      end
    end
  end

end
