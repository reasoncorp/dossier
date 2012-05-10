require 'spec_helper'

describe Dossier::Format::Currency do

  before :each do
    @currency = Dossier::Format::Currency.new(1025)
  end

  it "formats as U.S. dollars" do
    @currency.format.should eq('$1,025.00')
  end

end
