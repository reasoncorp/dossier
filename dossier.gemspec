$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dossier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dossier"
  s.version     = Dossier::VERSION
  s.authors     = ["Adam Hunter"]
  s.email       = ["adamhunter@me.com"]
  s.summary     = "SQL based report generation."
  s.description = "Easy SQL based report generation with the ability to accept request parameters and render multiple formats."
  s.homepage    = "https://github.com/adamhunter/dossier"
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + %w[MIT-LICENSE Rakefile README.md VERSION]
  s.test_files = Dir["spec/**/*"] - %w[spec/dummy/config/dossier.yml]

  s.add_dependency "arel",            ">= 4.2.11.1"
  s.add_dependency "activesupport",   ">= 4.2.11.1"
  s.add_dependency "actionpack",      ">= 4.2.11.1"
  s.add_dependency "actionmailer",    ">= 4.2.11.1"
  s.add_dependency "railties",        ">= 4.2.11.1"
  s.add_dependency "haml",            ">= 5.1"
  s.add_dependency "responders",      ">= 2.4"

  s.add_development_dependency "activerecord",   ">= 4.2.11.1"
  s.add_development_dependency "sqlite3",        "~> 1.3.6"
  s.add_development_dependency "pry",            ">= 0.12.1"
  s.add_development_dependency "rspec-rails",    ">= 3.8.2"
  s.add_development_dependency "generator_spec", "~> 0.9.4"
  s.add_development_dependency "capybara",       "~> 3.23.0"
  s.add_development_dependency "simplecov",      "~> 0.16.1"
end
