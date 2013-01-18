require 'spec_helper'

describe Dossier::Adapter::ActiveRecord::Result do

  let(:ar_connection_results) { [] }
  let(:result)                { described_class.new(ar_connection_results) }

  describe "headers" do

    let(:fake_fields) { %[foo bar] }

    before :each do
      ar_connection_results.stub(:fields).and_return(fake_fields)
    end

    it "calls `fields` on its connection_results" do
      ar_connection_results.should_receive(:fields)
      result.headers
    end

    it "returns the fields from the connection_results" do
      expect(result.headers).to eq(fake_fields)
    end

  end

  describe "rows" do

    it "returns the connection_results" do
      expect(result.rows).to eq(ar_connection_results)
    end

  end
end

