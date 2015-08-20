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
          expect(Dossier::Adapter::SpecAdapter).to receive(:new).with(username: 'Timmy')
          described_class.new(dossier_adapter: 'spec_adapter', username: 'Timmy').adapter
        end

      end

      context "when not given a connection or a dossier_adapter option" do

        let(:loaded_orms) { raise 'implement in nested describe' }
        let(:client)   { 
          described_class.new(username: 'Jimmy').tap { |c|
            allow(c).to receive(:loaded_orms).and_return(loaded_orms)
          }
        }

        describe "if there is one known ORM loaded" do

          let(:loaded_orms) { [double(:class, name: 'ActiveRecord::Base')] }

          it "uses that ORM's adapter" do
            expect(Dossier::Adapter::ActiveRecord).to(
              receive(:new).with(username: 'Jimmy'))
            client.adapter
          end

        end

        context "if there are no known ORMs loaded" do
          
          let(:loaded_orms) { [] }

          it "raises an error" do
            expect{ client.adapter }.to raise_error(Dossier::Client::IndeterminableAdapter)
          end

        end

        describe "if there are multiple known ORMs loaded" do
          
          let(:loaded_orms) { [:orm1, :orm2] }

          it "raises an error" do
            expect{ client.adapter }.to raise_error(Dossier::Client::IndeterminableAdapter)
          end

        end

      end

    end

  end

  describe "instances" do

    let(:client)  { described_class.new(connection: connection) }
    let(:adapter) { double(:adapter) }

    before :each do
      allow(client).to receive(:adapter).and_return(adapter)
    end

    it "delegates `escape` to its adapter" do
      expect(adapter).to receive(:escape).with('Bobby Tables')
      client.escape('Bobby Tables')
    end

    it "delegates `execute` to its adapter" do
      expect(adapter).to receive(:execute).with('SELECT * FROM `primes`') # It's OK, it's in the cloud!
      client.execute('SELECT * FROM `primes`')
    end


  end

end
