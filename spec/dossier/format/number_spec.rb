require 'spec_helper'

describe Dossier::Format::Number do

  let(:formatter) { Dossier::Format::Number.new(nil) }

  describe "formatting" do
    it "formats numbers with commas" do
      formatter.value = 1025125 
    end

    it "formats numbers with commas" do
      formatter.value = '1025125' 
    end

    after :each do
      expect(formatter.format).to eq('1,025,125')
    end
  end
end
