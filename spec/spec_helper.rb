# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'rspec/rails'
require 'pry'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DB_CONFIG = Hash[
  [:mysql2].map do |adapter|
    path = "spec/fixtures/db/#{adapter}.yml"
    if File.exist?(path)
      [adapter, YAML.load_file(path).symbolize_keys]
    else
      nil
    end
  end.compact
].freeze

RSpec.configure do |config|
  config.mock_with :rspec

  config.after :each do
    Dossier.instance_variable_set(:@configuration, nil)
  end

  config.order = :random
end
