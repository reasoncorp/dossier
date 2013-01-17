require 'spec_helper'

describe Dossier::Client do

  let(:connection) { 
    double(:connection, class: double(:class, name: 'ActiveRecord::ConnectionAdapters::Mysql2Adapter')) 
  }

  describe "initialization" do

    describe "finding the correct adapter" do

      context "when given a connection object" do

        let(:client) { described_class.new(connection: connection) }

        it "determines the adapter from the connection's class" do
          expect(client.adapter).to be_a(Dossier::Adapter::ActiveRecord)
        end

      end

      context "when given a dossier_adapter option" do

        before :each do
          Dossier::Adapter::SpecAdapter = Struct.new(:options)
        end

        after :each do
          Dossier::Adapter.send(:remove_const, :SpecAdapter)
        end

        it "uses an adapter by that name" do
          Dossier::Adapter::SpecAdapter.should_receive(:new).with(username: 'Timmy')
          described_class.new(dossier_adapter: 'spec_adapter', username: 'Timmy')
        end

      end

      context "when not given a connection or a dossier_adapter option" do

        let(:client)   { described_class.new(username: 'Jimmy') }

        describe "if there is one known ORM loaded" do
          
          before :each do
            described_class.any_instance.stub(:loaded_orms).and_return([double(:class, name: 'ActiveRecord::Base')])
          end

          it "uses that ORM's adapter" do
            Dossier::Adapter::ActiveRecord.should_receive(:new).with(username: 'Jimmy')
            described_class.new(username: 'Jimmy')
          end

        end

        context "if there are no known ORMs loaded" do

          before :each do
            described_class.any_instance.stub(:loaded_orms).and_return([])
          end

          it "raises an error" do
            expect{described_class.new(username: 'Jimmy')}.to raise_error(Dossier::Client::IndeterminableAdapter)
          end

        end

        describe "if there are multiple known ORMs loaded" do

          before :each do
            described_class.any_instance.stub(:loaded_orms).and_return([:orm1, :orm2])
          end

          it "raises an error" do
            expect{described_class.new(username: 'Jimmy')}.to raise_error(Dossier::Client::IndeterminableAdapter)
          end

        end

      end

    end

  end

  describe "instances" do

    let(:client)  { described_class.new(connection: connection) }
    let(:adapter) { double(:adapter) }

    before :each do
      client.stub(:adapter).and_return(adapter)
    end

    it "delegates `escape` to its adapter" do
      adapter.should_receive(:escape).with('Bobby Tables')
      client.escape('Bobby Tables')
    end

    it "delegates `execute` to its adapter" do
      adapter.should_receive(:execute).with('SELECT * FROM `primes`') # It's OK, it's in the cloud!
      client.execute('SELECT * FROM `primes`')
    end


  end

end
