require 'spec_helper'

describe Dossier::Adapter::ActiveRecord do

  let(:ar_connection) { double(:activerecord_connection) }
  let(:adapter)       { described_class.new }

  describe "escaping" do

    before do
      allow(::ActiveRecord::Base).to receive(:connection) { ar_connection }
    end

    let(:dirty_value) { "Robert'); DROP TABLE Students;--" }
    let(:clean_value) { "'Robert\\'); DROP TABLE Students;--'" }

    it "delegates to the connection" do
      expect(ar_connection).to receive(:quote).with(dirty_value)
      adapter.escape(dirty_value)
    end

    it "returns the connection's escaped value" do
      allow(ar_connection).to receive(:quote).and_return(clean_value)
      expect(adapter.escape(dirty_value)).to eq(clean_value)
    end

  end

  describe "execution" do
    before do
      allow(::ActiveRecord::Base).to receive(:connection) { ar_connection }
    end

    let(:query)                { 'SELECT * FROM `people_who_resemble_vladimir_putin`' }
    let(:connection_results)   { [] }
    let(:adapter_result_class) { Dossier::Adapter::ActiveRecord::Result}

    it "delegates to the connection" do
      expect(ar_connection).to receive(:exec_query).with("\n#{query}")
      adapter.execute(query)
    end

    it "builds an adapter result" do
      allow(ar_connection).to receive(:exec_query).and_return(connection_results)
      expect(adapter_result_class).to receive(:new).with(connection_results)
      adapter.execute(:query)
    end

    it "returns the adapter result" do
      allow(ar_connection).to receive(:exec_query).and_return(connection_results)
      expect(adapter.execute(:query)).to be_a(adapter_result_class)
    end

    it "rescues any errors and raises a Dossier::ExecuteError" do
      allow(ar_connection).to receive(:exec_query).and_raise(StandardError.new('wat'))
      expect{ adapter.execute(:query) }.to raise_error(Dossier::ExecuteError)
    end

  end

end
