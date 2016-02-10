$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dossier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dossier"
  s.version     = Dossier::VERSION
  s.authors     = ["TMA IT"]
  s.email       = ["developer@tma1.com"]
  s.summary     = "SQL based report generation."
  s.description = "Easy SQL based report generation with the ability to accept request parameters and render multiple formats."
  s.homepage    = "https://github.com/tma1/dossier"
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + %w[MIT-LICENSE Rakefile README.md VERSION]
  s.test_files = Dir["spec/**/*"] - %w[spec/dummy/config/dossier.yml]

  s.add_dependency "arel",            ">= 3.0"
  s.add_dependency "activesupport",   ">= 3.2"
  s.add_dependency "actionpack",      ">= 3.2"
  s.add_dependency "actionmailer",    ">= 3.2"
  s.add_dependency "railties",        ">= 3.2"
  # s.add_dependency "haml",            ">= 3.1"
  s.add_dependency "responders",      ">= 1.1"

  s.add_development_dependency "activerecord",   ">= 3.2"
  s.add_development_dependency "sqlite3",        ">= 1.3.6"
  s.add_development_dependency "pry",            ">= 0.10.1"
  s.add_development_dependency "rspec-rails",    ">= 3.3.3"
  s.add_development_dependency "generator_spec", "~> 0.9.3"
  s.add_development_dependency "capybara",       "~> 2.4.4"
  s.add_development_dependency "simplecov",      "~> 0.10.0"
end
