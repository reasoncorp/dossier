require 'spec_helper'

describe Dossier::ConnectionUrl do

  let(:database_url) { "mysql2://root:password@127.0.0.1/myapp_development?encoding=utf8" }   
  
  it "parses the url provided into a hash" do
    connection_options = described_class.new(database_url).to_hash
    expected_options = { adapter: "mysql2",   database: "myapp_development",user:"root",
                         password:"password", encoding:"utf8", host: "127.0.0.1"}
    expect(connection_options).to eq(expected_options)
  end

  it "parses DATABASE_URL into a hash if no url is provided" do
    old_db_url = ENV.delete "DATABASE_URL"
    ENV["DATABASE_URL"] = "postgres://localhost/foo"
    expected_options = {adapter: "postgresql",host: "localhost",database: "foo"}
    connection_options = described_class.new.to_hash
    expect(connection_options).to eq(expected_options)
    ENV["DATABASE_URL"] = old_db_url
  end

end
