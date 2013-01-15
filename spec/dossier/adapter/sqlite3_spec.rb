require 'spec_helper'
require 'dossier/adapter/sqlite3'

describe Dossier::Adapter::SQLite3 do

  let(:db_config) { DB_CONFIG[:sqlite3] }
  let(:adapter) { described_class.new(db_config) }

  describe "initialize" do
    it "instantiates its connection_class" do
      described_class.connection_class.should_receive(:new).with(db_config[:database])
      adapter
    end
  end

  describe "instance methods" do

    let(:example_query) { 'SELECT * FROM employees' }

    describe "execute" do

      it "calls `execute` on the connection" do
        adapter.connection.should_receive(:execute).with(example_query)
        adapter.execute(example_query)
      end

      it "returns an adapter result" do
        expect(adapter.execute(example_query)).to be_a(Dossier::Adapter::SQLite3::Result)
      end

      describe "handling SQL syntax errors" do

        it "raises a Dossier::ExecuteError containing the bad query" do
          query = "FROM SELECT romeo WHERE FROM art SELECT romeo"
          expect{adapter.execute(query)}.to raise_error(
            Dossier::ExecuteError, /#{query}/
          )
        end

      end

    end

    describe "escape" do

      it "gets its connection to escape the value" do
        adapter.connection.should_receive(:escape).with('dAnGeRoUsNeSs!#')
        adapter.escape('dAnGeRoUsNeSs!#')
      end

    end

    describe Dossier::Adapter::SQLite3::Result do

      describe "headers" do

        it "calls `fields` on its results" do
          mock_results = mock(:results, fields: [])
          results = Dossier::Adapter::SQLite3::Result.new(mock_results)
          mock_results.should_receive(:fields)
          results.headers
        end

      end

      describe "rows" do

        it "responds to `each`" do
          results = adapter.execute(example_query)
          expect(results.rows).to respond_to(:each)
        end

      end
    end

  end

end
