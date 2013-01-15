# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'rspec/rails'
require 'pry'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DB_CONFIG = [:mysql2].reduce({}) do |config, adapter_name|
  config.tap do |hash|
    path = "spec/fixtures/db/#{adapter_name}.yml"
    if File.exist?(path)
      hash[adapter_name] = YAML.load_file(path).symbolize_keys
    end
  end
end.freeze

RSpec.configure do |config|
  config.mock_with :rspec

  config.after :each do
    Dossier.instance_variable_set(:@configuration, nil)
  end

  config.order = :random
end
