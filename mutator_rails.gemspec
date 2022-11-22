# frozen_string_literal: true

require File.expand_path('../lib/mutator_rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'mutator_rails'
  gem.version       = MutatorRails::VERSION.dup
  gem.authors       = %w[Tim\ Chambers Jason\ Dinsmore]
  gem.email         = ['tim@hint.io', 'jason@hint.io']
  gem.summary       = 'Integrate automated mutation testing into Rails.'
  gem.description   = 'Automate mutation testing to find weaknesses in code'
  gem.homepage      = 'https://github.com/hintmedia/mutator_rails'
  gem.license       = 'MIT'

  gem.require_paths             = ['lib']
  gem.required_rubygems_version = '>= 1.3.6'
  gem.required_ruby_version     = '>= 2.3'

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")

  gem.add_development_dependency 'actionview',           '>= 6.1.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rails',                '>= 4'
  gem.add_development_dependency 'mutant',               '~> 0.8'
  gem.add_development_dependency 'mutant-rspec',         '~> 0.8'
  gem.add_development_dependency 'concord'
  gem.add_development_dependency 'procto'
  gem.add_development_dependency 'adamantium'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'reek',                 '~> 4'
  gem.add_development_dependency 'nokogiri',             '>= 1.13.0'
  gem.add_development_dependency 'loofah',               '>= 2.3.1'
  gem.add_development_dependency 'rspec-mocks'
  gem.add_development_dependency 'rspec_junit_formatter'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'rspec-collection_matchers'
end
