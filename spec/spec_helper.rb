ENV['RAILS_ENV']   = 'test'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start
Coveralls.wear!('rails')

require File.expand_path("../sample/config/application.rb",  __FILE__)
require 'rspec/rails'
require 'pry'
require 'generator_spec'
require 'capybara/rspec'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DB_CONFIG = [:mysql2, :sqlite3, :postgresql].reduce({}) do |config, adapter_name|
  config.tap do |hash|
    path = "spec/fixtures/db/#{adapter_name}.yml"
    hash[adapter_name] = YAML.load_file(path).symbolize_keys if File.exist?(path)
  end
end.freeze

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec

  config.before :suite do
    DB_CONFIG.keys.each do |adapter|
      Dossier::Factory.send("#{adapter}_create_employees")
      Dossier::Factory.send("#{adapter}_seed_employees")
    end
  end

  config.after :each do
    Dossier.instance_variable_set(:@configuration, nil)
  end

  config.order = :random
end
