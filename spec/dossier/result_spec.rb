require 'spec_helper'

describe Dossier::Result do

  module EachStubber
    def each
      @adapter_results.each do |row|
        yield row
      end
    end
  end

  let(:report)         { TestReport.new }
  let(:result_row)     { {mascot: 'platapus', cheese: 'bleu'} }
  let(:adapter_result) { [result_row] }
  let(:result)         { Dossier::Result.new(adapter_result, report).tap { |r| r.extend(EachStubber) } }

  describe "initialization with an adapter result object" do

    it "will raise if the object isn't given" do
      expect {Dossier::Result.new}.to raise_error(ArgumentError)
    end

    it "will raise if the object isn't enumerable" do
      expect {Dossier::Result.new(37, report)}.to raise_error(ArgumentError)
    end

    it "can extract the fields queried" do
      adapter_result.should_receive(:fields).and_return([])
      result.headers
    end

    it "can extract the values from the results" do
      result.should_receive(:map)
      result.rows
    end

    describe "structure" do

      it "can return an array of hashes" do
        expect(result.hashes).to eq([result_row])
      end

      it "can return an array of arrays" do
        result.stub(:headers).and_return(%w[mascot cheese])
        expect(result.arrays).to eq([%w[mascot cheese], %w[platapus bleu]])
      end

    end

  end

  describe "subclasses" do

    describe Dossier::Result::Formatted do

      let(:result) { Dossier::Result::Formatted.new(adapter_result, report) }

      describe "each" do

        it "calls :each on on its adapter's results" do
          adapter_result.should_receive(:each)
          result.each
        end

        it "formats each of the adapter's results" do
          result.should_receive(:format).with(result_row)
          result.each { |result| }
        end

      end

      describe "format" do

        it "it raises unless its argument responds to :[]" do
          expect {result.format(Object.new)}.to raise_error(ArgumentError)
        end

      end

      describe "footer" do
        let(:report) { TestReport.new(footer: 3) }
        let(:adapter_result) { 7.times.map { result_row } }

        it "has 4 result rows" do
          expect(result.body.count).to eq(4)
        end

        it "has 3 footer rows" do
          expect(result.footers.count).to eq(3)
        end

      end

    end

    describe Dossier::Result::Unformatted do

      let(:result) { Dossier::Result::Unformatted.new(adapter_result, report) }

      describe "each" do

        it "calls :each on on its adapter's results" do
          adapter_result.should_receive(:each)
          result.each
        end

        it "does not format the results" do
          result.should_not_receive(:format)
          result.each { |result| }
        end

      end

    end

  end

end
