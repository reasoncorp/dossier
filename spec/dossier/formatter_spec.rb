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
      expect(formatter.url_for(route)).to eq('/woo')
    end

    it "allows link generation" do
      expect(formatter.link_to('Woo!', route)).to eq('<a href="/woo">Woo!</a>')
    end

    it "allows usage of url helpers" do
      expect(formatter.url_helpers.woo_path).to eq('/woo')
    end
  end

end
