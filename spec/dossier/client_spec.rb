require 'spec_helper'

describe Dossier::Client do

  let(:db_config) { DB_CONFIG[:mysql2] }

  it "loads the correct database adapter based on the options given" do
    client = Dossier::Client.new(db_config.merge adapter: 'mysql2')
    expect(client.adapter.class.name).to eq('Dossier::Adapter::Mysql2')
  end

  it "passes the remaining options to the adapter" do
    Dossier::Client.any_instance.stub(:adapter_class).and_return(OpenStruct)
    OpenStruct.should_receive(:new).with(username: 'Jimmy', password: 'smith&wesson')
    client = Dossier::Client.new(adapter: 'mysql2', username: 'Jimmy', password: 'smith&wesson')
  end

end
