# frozen_string_literal: true

require File.expand_path('../lib/mutator_rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'mutator_rails'
  gem.version       = MutatorRails::VERSION.dup
  gem.authors       = %w[Tim\ Chambers Jason\ Dinsmore]
  gem.email         = ['tim@possibilogy.com', 'jason@dinjas.com']
  gem.summary       = 'Integrate automated mutation testing into Rails.'
  gem.description   = 'Automate mutation testing to find weaknesses in code'
  gem.homepage      = 'https://github.com/dinj-oss/mutator_rails'
  gem.license       = 'MIT'

  gem.require_paths             = ['lib']
  gem.required_rubygems_version = '>= 1.3.6'
  gem.required_ruby_version     = '>= 2.3'

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")

  gem.add_development_dependency 'bundler',              '~> 1.15'
  gem.add_development_dependency 'rake',                 '~> 12.0'
  gem.add_development_dependency 'rails',                '>= 4.0'
  gem.add_development_dependency 'rspec-core',           '~> 3.6.0'
  gem.add_development_dependency 'rspec-expectations',   '~> 3.6.0'
  gem.add_development_dependency 'rspec_junit_formatter'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'rspec-collection_matchers'
  gem.add_development_dependency 'rspec-mocks',          '~> 3.6.0'
  gem.add_development_dependency 'mutant',               '~> 0.8.14'
  gem.add_development_dependency 'mutant-rspec',         '~> 0.8.14'
  gem.add_development_dependency 'concord',              '~> 0.1.4'
  gem.add_development_dependency 'procto',               '~> 0.0.3'
  gem.add_development_dependency 'adamantium',           '~> 0.2.0'
  gem.add_development_dependency 'reek',                 '~> 4.7.2'
end
