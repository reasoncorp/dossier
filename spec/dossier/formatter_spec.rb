require 'spec_helper'

describe Dossier::Formatter do

  let(:formatter) { described_class }

  describe "methods from ActionView::Helpers::NumberHelper" do

    it "formats numbers with commas" do
      expect(formatter.number_with_delimiter(1025125)).to eq('1,025,125')
    end

    it "formats as U.S. dollars" do
      expect(formatter.number_to_currency(1025)).to eq('$1,025.00')
    end

  end

  it "formats as U.S. dollars from cents" do
    expect(formatter.number_to_currency_from_cents(102500)).to eq('$1,025.00')
  end

  describe "route formatting" do
    let(:route) { {controller: :site, action: :index} }

    it "allows URL generation" do
      expect(formatter.url_formatter.url_for(route)).to eq('/woo')
    end

    it "allows link generation" do
      expect(formatter.url_formatter.link_to('Woo!', route)).to eq('<a href="/woo">Woo!</a>')
    end

    it "allows usage of url helpers" do
      expect(formatter.url_formatter.url_helpers.woo_path).to eq('/woo')
    end
  end

  describe "custom formatters" do
    describe "commafy_number" do
      formats = {
        10_000            => '10,000',
        10_000.01         => '10,000.01',
        1_000_000_000.001 => '1,000,000,000.001',
        '12345.6789'      => '12,345.6789'
      }.each { |base, formatted|
        it "formats #{base} as #{formatted}" do
          expect(formatter.commafy_number(base)).to eq formatted
        end
      }
      it "will return the expected precision if too large" do
        expect(formatter.commafy_number(1_000.23523563, 2)).to eq '1,000.24'
      end

      it "will return the expected precision if too small" do
        expect(formatter.commafy_number(1_000, 5)).to eq '1,000.00000'
      end
    end

    describe "number_to_dollars" do
      formats = {
        10_000            => '$10,000.00',
        10_000.00         => '$10,000.00',
        1_000_000_000.000 => '$1,000,000,000.00',
        '12345.6788'      => '$12,345.68'
      }.each { |base, formatted|
        it "formats #{base} as #{formatted}" do
          expect(formatter.number_to_dollars(base)).to eq formatted
        end
      }
    end
  end

end
