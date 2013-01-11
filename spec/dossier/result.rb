require 'spec_helper'

describe Dossier::Result do
  before :each do 
    @report = TestReport.new
  end

  describe "initialization with an adapter result object" do

    it "will raise if the object isn't given" do
      expect {Dossier::Result.new}.to raise_error(ArgumentError)
    end

    it "will raise if the object isn't enumerable" do
      expect {Dossier::Result.new(37, @report)}.to raise_error(ArgumentError)
    end

  end

  describe "each" do

    before :each do
      @hash = {}
      @array = [@hash]
      @results = Dossier::Result.new(@array, @report)
    end

    it "calls :each on on its adapter's results" do
      @array.should_receive(:each)
      @results.each
    end

    it "formats each of the adapter's results" do
      @results.should_receive(:format).with(@hash)
      @results.each {|row| }
    end

  end

  describe "format" do

    before :each do
      @hash = {}
      @array = [@hash]
      @results = Dossier::Result.new(@array, @report)
    end

    it "it raises unless its argument responds to :[]" do
      expect {@results.format(Object.new)}.to raise_error(ArgumentError)
    end

  end

end
