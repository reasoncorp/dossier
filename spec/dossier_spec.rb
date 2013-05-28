require 'spec_helper'

describe Dossier do
  it "is a module" do
    Dossier.should be_a(Module)
  end

  it "is configurable"  do
    Dossier.configure
    Dossier.configuration.should_not be_nil
  end

  it "has a configuration" do
    Dossier.configure
    Dossier.configuration.should be_a(Dossier::Configuration)
  end

  it "allows configuration via a block" do
    some_client = Object.new
    Dossier.configure do |config|
      config.client = some_client
    end
    Dossier.configuration.client.should eq(some_client)
  end

  it "exposes the configurations client via Dossier.client" do
    Dossier.configure
    Dossier.configuration.should_receive(:client)
    Dossier.client
  end

  describe "report naming" do
    let(:klass) { HelloMyFriendsReport }
    let(:name)  { 'hello_my_friends' }

    it "converts a report class to a report name" do
      expect(Dossier.class_to_name(klass)).to eq(name)
    end

    it "converting a report name to a report class" do
      expect(Dossier.name_to_class(name)).to eq(klass)
    end

    describe "with namespaces" do
      let(:klass) { Cats::Are::SuperFunReport }
      let(:name)  { 'cats/are/super_fun' }

      it "converts a report class to a report name" do
        expect(Dossier.class_to_name klass).to eq name
      end

      it "converts a report name to a report class" do
        expect(Dossier.name_to_class name).to eq klass
      end
    end
  end
end
