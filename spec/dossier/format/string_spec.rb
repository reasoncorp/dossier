require 'spec_helper'

describe Dossier::Format::String do
  
  before :each do
    @string = Dossier::Format::String.new('howdy there')
  end

  it "outputs the raw value as the formatted value" do
    @string.format.should eq(@string.value)
  end

end
