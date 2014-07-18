require 'spec_helper'

describe Dossier::ConnectionUrl do

  it "parses the url provided into a hash" do
    database_url = "mysql2://root:password@127.0.0.1/myapp_development?encoding=utf8"

    connection_options = described_class.new(database_url).to_hash
    expected_options = { adapter: "mysql2",   database: "myapp_development", username:"root",
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

  it "translates postgres" do
    database_url  = "postgres://user:secret@localhost/mydatabase"
    connection_options = described_class.new(database_url).to_hash

    expect(connection_options[:adapter]).to eq("postgresql")
  end

  it "supports additional options" do
    database_url  = "postgresql://user:secret@remotehost.example.org:3133/mydatabase?encoding=utf8&random_key=blah"
    connection_options = described_class.new(database_url).to_hash

    expect(connection_options[:encoding]).to eq("utf8")
    expect(connection_options[:random_key]).to eq("blah")
    expect(connection_options[:port]).to eq(3133)
  end

  it "drops empty values" do
    database_url  = "postgresql://localhost/mydatabase"
    connection_options = described_class.new(database_url).to_hash
    expect(connection_options.slice(:username, :password, :port)).to be_empty
  end

end
