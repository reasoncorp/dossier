require 'spec_helper'

describe Dossier::StreamCSV do
  let(:collection) {
    [
      %w[hello there sir how are you],
      %w[i am well thanks for asking]
    ]
  }
  let(:headers) { %w[w1 w2 w3 w4 w5 w6] }
  let(:streamer) { described_class.new(collection, headers) }

  describe "headers" do
    it "allows passing headers" do
      expect(streamer.headers).to eq headers
    end

    it "does not format the headers when streamed" do
      formatted = nil
      streamer.each { |r| formatted = r; break }
      expect(formatted).to eq %w[w1 w2 w3 w4 w5 w6].to_csv
    end

    describe "using the first element of the collection for headers" do
      let(:streamer)  { described_class.new(collection) }
      let!(:original) { collection.dup }

      it "takes the first element of the collection to be the headers" do
        expect(streamer.headers).to eq original.first
      end
      
      it "*only* takes the first element off the collection" do
        streamer.headers
        expect(streamer.headers).to eq original.first
      end
    end
    
    describe "explicitly false headers" do
      let(:streamer) { described_class.new(collection, false) }

      it "will not use headers if they are explicitly false" do
        expect(streamer.headers).to be_nil
      end

      it "will not stream headers if they are not set" do
        streamer = described_class.new(collection, false)
        expect([].tap { |a| streamer.each { |r| a << r } }).to eq collection.map(&:to_csv)
      end
    end
  end

  it "calls to csv on each member of the collection" do
    collection.each { |row| expect(row).to receive(:to_csv) }
    streamer.each {}
  end

  describe "exceptions" do
    let(:output) { String.new }
    let(:error)  { "Woooooooo cats are fluffy!" }
    before(:each) {
      allow(collection[0]).to receive(:to_csv).and_raise(error)
    }

    it "provides a backtrace if local request" do
      allow(Rails.application.config).to receive(:consider_all_requests_local).and_return(true)
      streamer.each { |line| output << line }
      expect(output).to include(error)
    end

    it "provides a simple error if not a local request" do
      allow(Rails.application.config).to receive(:consider_all_requests_local).and_return(false)
      streamer.each { |line| output << line }
      expect(output).to match(/something went wrong/)
    end
  end

end
