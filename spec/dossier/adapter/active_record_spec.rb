require 'spec_helper'

describe Dossier::Adapter::ActiveRecord do

  let(:ar_connection) { double(:activerecord_connection) }
  let(:adapter)       { described_class.new({connection: ar_connection}) }

  describe "escaping" do

    let(:dirty_value) { "Robert'); DROP TABLE Students;--" }
    let(:clean_value) { "'Robert\\'); DROP TABLE Students;--'" }

    it "delegates to the connection" do
      ar_connection.should_receive(:quote).with(dirty_value)
      adapter.escape(dirty_value)
    end

    it "returns the connection's escaped value" do
      ar_connection.stub(:quote).and_return(clean_value)
      expect(adapter.escape(dirty_value)).to eq(clean_value)
    end

  end

  describe "execution" do

    let(:query)                { 'SELECT * FROM `people_who_resemble_vladimir_putin`' }
    let(:connection_results)   { [] }
    let(:adapter_result_class) { Dossier::Adapter::ActiveRecord::Result}

    it "delegates to the connection" do
      ar_connection.should_receive(:exec_query).with("\n#{query}")
      adapter.execute(query)
    end

    it "builds an adapter result" do
      ar_connection.stub(:exec_query).and_return(connection_results)
      adapter_result_class.should_receive(:new).with(connection_results)
      adapter.execute(:query)
    end

    it "returns the adapter result" do
      ar_connection.stub(:exec_query).and_return(connection_results)
      expect(adapter.execute(:query)).to be_a(adapter_result_class)
    end

    it "rescues any errors and raises a Dossier::ExecuteError" do
      ar_connection.stub(:exec_query).and_raise(StandardError.new('wat'))
      expect{ adapter.execute(:query) }.to raise_error(Dossier::ExecuteError)
    end

  end

end
