require 'spec_helper'

describe Dossier::Format::CurrencyInCents do

  before :each do
    @currency = Dossier::Format::CurrencyInCents.new(102500)
  end

  it "formats as U.S. dollars" do
    @currency.format.should eq('$1,025.00')
  end

end
