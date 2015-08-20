require 'spec_helper'

describe Dossier do
  it "is a module" do
    expect(Dossier).to be_a(Module)
  end

  it "is configurable"  do
    Dossier.configure
    expect(Dossier.configuration).to_not be_nil
  end

  it "has a configuration" do
    Dossier.configure
    expect(Dossier.configuration).to be_a(Dossier::Configuration)
  end

  it "allows configuration via a block" do
    some_client = Object.new
    Dossier.configure do |config|
      config.client = some_client
    end
    expect(Dossier.configuration.client).to eq(some_client)
  end

  it "exposes the configurations client via Dossier.client" do
    Dossier.configure
    expect(Dossier.configuration).to receive(:client)
    Dossier.client
  end
end
