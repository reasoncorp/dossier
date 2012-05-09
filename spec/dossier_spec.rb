require 'spec_helper'

describe Dossier do
  it "is a module" do
    Dossier.should be_a(Module)
  end

  it "is configuraable"  do
    Dossier.configure
    Dossier.configuration.should_not be_nil
  end

  it "has a configuration" do
    Dossier.configure
    Dossier.configuration.should be_a(Dossier::Configuration)
  end

  it "allows configuration via a block" do
    @mysql_client = Mysql2::Client.new
    Dossier.configure do |config|
      config.client = @mysql_client
    end
    Dossier.configuration.client.should eq(@mysql_client)
  end

  it "exposes the configurations client via Dossier.client" do
    Dossier.configuration.should_receive(:client)
    Dossier.client
  end
end
