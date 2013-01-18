require 'spec_helper'

describe Dossier::Adapter::ActiveRecord::Result do

  let(:ar_connection_results) { double(:results, columns: %w[name age], rows: [['bob', 20], ['sue', 30]]) }
  let(:result)                { described_class.new(ar_connection_results) }

  describe "headers" do

    let(:fake_columns) { %[foo bar] }

    it "calls `columns` on its connection_results" do
      ar_connection_results.should_receive(:columns)
      result.headers
    end

    it "returns the columns from the connection_results" do
      expect(result.headers).to eq(ar_connection_results.columns)
    end

  end

  describe "rows" do

    it "returns the connection_results" do
      expect(result.rows).to eq(ar_connection_results.rows)
    end

  end
end

