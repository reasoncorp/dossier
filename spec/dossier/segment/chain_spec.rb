require 'spec_helper'

describe Dossier::Segment::Chain do
  let(:report_class)    { Class.new(Dossier::Report) }
  let(:segmenter_class) { report_class.segmenter_class }
  let(:definition)      { Dossier::Segment::Definition.new(segmenter_class, :foo) }
  let(:next)            { Dossier::Segment::Definition.new(segmenter_class, :bar) }
  let(:chain)           { described_class.new.tap { |c| c << definition } }

  it "allows #at access of definitions" do
    expect(chain.at 0).to eq definition
  end

  it "aliases [] to at" do
    expect(chain[0]).to eq definition
  end

  it "conforms to enumerable" do
    chain.each { |d| expect(d).to eq definition }
  end

  describe "appending to the chain" do
    before :each do
      chain << self.next
    end

    it "uses <<" do
      expect(chain.at 1).to eq self.next
    end

    it "allows accessing the end" do
      expect(chain.last).to eq self.next
    end

    it "assigns the previous segment the given segment as next" do
      expect(chain.first.next).to eq self.next
    end

    it "assigns the next segment the previous segment as prev" do
      expect(chain.last.prev).to eq chain.first
    end
  end
end
