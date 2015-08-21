require 'spec_helper'

describe Dossier::Result do

  module AbstractMock
    def each
      adapter_results.rows.each do |row|
        yield row
      end
    end

    def headers
      raw_headers
    end
  end

  let(:report)         { TestReport.new }
  let(:result_row)     { {'mascot' => 'platapus', 'cheese' => 'bleu'} }
  let(:adapter_result) { double(:adapter_result, rows: [result_row.values], headers: result_row.keys) }
  let(:result_class)   { Class.new(described_class) { include AbstractMock } }
  let(:result)         { result_class.new(adapter_result, report) }

  it "requires each to be overridden" do
    expect { described_class.new(adapter_result, report).each }.to raise_error(NotImplementedError, /result must define/i)
  end
  
  it "requires headers to be overridden" do
    expect { described_class.new(adapter_result, report).headers }.to raise_error(NotImplementedError, /headers/i)
  end

  describe "initialization with an adapter result object" do

    it "will raise if the object isn't given" do
      expect {Dossier::Result.new}.to raise_error(ArgumentError)
    end

    it "can extract the fields queried" do
      expect(adapter_result).to receive(:headers).and_return([])
      result.headers
    end

    it "can extract the values from the adapter results" do
      expect(result).to receive(:to_a)
      result.rows
    end

    describe "structure" do

      it "can return an array of hashes" do
        expect(result.hashes).to eq([result_row])
      end

      it "can return an array of arrays" do
        allow(result).to receive(:headers).and_return(%w[mascot cheese])
        expect(result.arrays).to eq([%w[mascot cheese], %w[platapus bleu]])
      end

    end

  end

  describe "subclasses" do

    describe Dossier::Result::Formatted do

      let(:result) { Dossier::Result::Formatted.new(adapter_result, report) }

      describe "headers" do
        it "formats the headers by calling format_header" do
          adapter_result.headers.each { |h| expect(result.report).to receive(:format_header).with(h) }
          result.headers
        end
      end

      describe "hashing" do
        it "does not format the keys of the hash" do
          hash = result.hashes.first
          expect(hash.keys).to eq %w[mascot cheese]
        end
      end

      describe "each" do

        it "calls :each on on its adapter's results" do
          expect(adapter_result.rows).to receive(:each)
          result.each { |result| }
        end

        it "formats each of the adapter's results" do
          expect(result).to receive(:format).with(result_row.values)
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
          expect(result.report).to receive(:format_mascot).with('platapus')
          result.format(row)
        end

        it "calls the default format_column method otherwise" do
          expect(result.report).to receive(:format_column).with('cheese', 'bleu')
          result.format(row)
        end
      end

      describe "footer" do
        let(:report) { TestReport.new(footer: 3) }
        let(:adapter_result_rows) { 7.times.map { result_row.values } }

        before :each do
          allow(adapter_result).to receive(:rows).and_return(adapter_result_rows)
        end

        it "has 4 result rows" do
          expect(result.body.count).to eq(4)
        end

        it "has 3 footer rows" do
          expect(result.footers.count).to eq(3)
        end

        describe "with empty results" do
          let(:adapter_result_rows) { [] }

          it "has an empty body" do
            expect(result.body.count).to be_zero
          end
        end

      end

    end

    describe Dossier::Result::Unformatted do

      let(:result) { Dossier::Result::Unformatted.new(adapter_result, report) }

      describe "each" do

        it "calls :each on on its adapter's results" do
          expect(adapter_result.rows).to receive(:each)
          result.each { |result| }
        end

        it "does not format the results" do
          expect(result).not_to receive(:format)
          result.each { |result| }
        end

      end

    end

  end

end
