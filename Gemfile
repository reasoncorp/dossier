source "https://rubygems.org"

gemspec

RAILS_VERSION = ENV.fetch('RAILS_VERSION', '4.2.3')
gem "activesupport", RAILS_VERSION
gem "actionpack",    RAILS_VERSION
gem "actionmailer",  RAILS_VERSION
gem "railties",      RAILS_VERSION
gem "activerecord",  RAILS_VERSION

# gems used by the dummy application
gem "jquery-rails"
gem "mysql2"
gem "pg"
gem 'coveralls', require: false

# test unit removed from stdlib in ruby 2.2.0
gem 'test-unit' if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2.0')
