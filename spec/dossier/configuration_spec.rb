require 'spec_helper'

describe Dossier::Configuration do
  
  let(:connection_options){ YAML.load_file(Rails.root.join('config', 'dossier.yml'))[Rails.env].symbolize_keys }
  let(:old_database_url) { ENV.delete "DATABASE_URL"}  
  
  before :each do 
    Dossier.configure
    @config = Dossier.configuration
  end

  after :each do
    ENV["DATABASE_URL"] = old_database_url
  end

  describe "defaults" do
    it "uses the rails configuration directory for the config path" do
      @config.config_path.should eq(Rails.root.join("config", "dossier.yml"))
    end
  end

  describe "client" do
    
    it %q{uses ENV["DATABASE_URL"] to merge with config/dossier.yml to setup the client} do
      ENV['DATABASE_URL'] = "mysql2://localhost/dossier_test"
      options = connection_options.merge Dossier::ConnectionUrl.new.to_hash
      expect(Dossier::Client).to receive(:new).with(options)
      Dossier.configure    
    end

    it "uses config/dossier.yml to setup the client" do
      expect(Dossier::Client).to receive(:new).with(connection_options)
      Dossier.configure
    end

    it "will raise an exception if config/dossier.yml cannot be read" do
      config_path = Rails.root.join('config')
      FileUtils.mv config_path.join('dossier.yml'), config_path.join('dossier.yml.test')
      expect { Dossier.configure }.to raise_error(Dossier::ConfigurationMissingError)
      FileUtils.mv config_path.join('dossier.yml.test'), config_path.join('dossier.yml')
    end

    it "will setup the connection options" do
      @config.connection_options.should be_a(Hash)
    end
  end

end
