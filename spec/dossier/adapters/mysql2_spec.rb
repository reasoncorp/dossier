require 'spec_helper'
require 'dossier/adapters/mysql2'

describe Dossier::Adapters::Mysql2 do

  let(:db_config) { YAML.load_file('spec/fixtures/db/mysql2.yml').symbolize_keys! }
  let(:adapter) { described_class.new(db_config) }

  describe "initialize" do
    it "instantiates its connection_class" do
      described_class.connection_class.should_receive(:new).with(described_class.defaults.merge(db_config))
      adapter
    end
  end

  describe "instance methods" do

    let(:example_query) { 'SELECT * FROM employees' }

    describe "execute" do

      it "calls `query` on the connection" do
        adapter.connection.should_receive(:query).with(example_query)
        adapter.execute(example_query)
      end

      it "stores the query results" do
        adapter.stub(:connection).and_return(mock(:adapter, query: 'some results!'))
        adapter.should_receive(:results=).with('some results!')
        adapter.execute(example_query)
      end
    end

    describe "escape" do

      it "gets its connection to escape the value" do
        adapter.connection.should_receive(:escape).with('dAnGeRoUsNeSs!#')
        adapter.escape('dAnGeRoUsNeSs!#')
      end

    end

    describe "headers" do

      let(:mock_results) { mock(:results) }
    
      it "calls `fields` on its results" do
        adapter.stub(:results).and_return(mock_results)
        mock_results.should_receive(:fields)
        adapter.headers
      end

    end

    describe "results" do

      it "responds to `each`" do
        adapter.execute(example_query)
        expect(adapter.results).to respond_to(:each)
      end

    end

  end

end
