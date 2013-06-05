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
end
