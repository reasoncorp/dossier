require 'spec_helper'

describe Dossier::Format::Object do
  
  before :each do
    @object = Dossier::Format::Object.new(Date.today)
  end

  it "outputs the raw value as the formatted value" do
    @object.format.should eq(@object.value)
  end

end
