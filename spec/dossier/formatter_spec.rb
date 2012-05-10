require 'spec_helper'

describe Dossier::Formatter do

  before :each do
    @formatter = Dossier::Formatter.new(@value = 1)
  end

  it "must receive a value when initialized" do
    expect {Dossier::Formatter.new}.to raise_error(ArgumentError)
  end

  it "provides access to the raw value it was initialized with" do
    @formatter.value.should eq(@value)
  end

  it "will format when cast as a string" do
    @formatter.should_receive(:format)
    @formatter.to_s
  end

  it "will raise a NotImplementedError when 'format' is called" do
    expect {@formatter.format}.to raise_error(NotImplementedError)
  end

end
