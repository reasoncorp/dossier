require 'spec_helper'

describe Dossier::Result do

  module EachStubber
    def each
      adapter_results.rows.each do |row|
        yield row
      end
    end
  end

  let(:report)         { TestReport.new }
  let(:result_row)     { {'mascot' => 'platapus', 'cheese' => 'bleu'} }
  let(:adapter_result) { double(:adapter_result, rows: [result_row.values], headers: result_row.keys) }
  let(:result)         { Dossier::Result.new(adapter_result, report).tap { |r| r.extend(EachStubber) } }

  it "requires each to be overridden" do
    expect { described_class.new(adapter_result, report).each }.to raise_error(NotImplementedError, /result must define/i)
  end

  describe "initialization with an adapter result object" do

    it "will raise if the object isn't given" do
      expect {Dossier::Result.new}.to raise_error(ArgumentError)
    end

    it "can extract the fields queried" do
      adapter_result.should_receive(:headers).and_return([])
      result.headers
    end

    it "can extract the values from the adapter results" do
      result.should_receive(:to_a)
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

      describe "headers" do
        it "formats the headers by calling format_header" do
          adapter_result.headers.each { |h| result.report.should_receive(:format_header).with(h) }
          result.headers
        end
      end

      describe "each" do

        it "calls :each on on its adapter's results" do
          adapter_result.rows.should_receive(:each)
          result.each { |result| }
        end

        it "formats each of the adapter's results" do
          result.should_receive(:format).with(result_row.values)
          result.each { |result| }
        end

      end

      describe "format" do
        let(:report) {
          Class.new(Dossier::Report) {
            def format_mascot(value); value.upcase; end
          }.new
        }

        let(:row) { result_row.values }

        it "raises unless its argument responds to :[]" do
          expect {result.format(Object.new)}.to raise_error(ArgumentError)
        end

        it "calls a custom formatter method if available" do
          result.report.should_receive(:format_mascot).with('platapus')
          result.format(row)
        end

        it "calls the default format_column method otherwise" do
          result.report.should_receive(:format_column).with('cheese', 'bleu')
          result.format(row)
        end
      end

      describe "footer" do
        let(:report) { TestReport.new(footer: 3) }
        let(:adapter_result_rows) { 7.times.map { result_row.values } }

        before :each do
          adapter_result.stub(:rows).and_return(adapter_result_rows)
        end

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
          adapter_result.rows.should_receive(:each)
          result.each { |result| }
        end

        it "does not format the results" do
          result.should_not_receive(:format)
          result.each { |result| }
        end

      end

    end

  end

end
