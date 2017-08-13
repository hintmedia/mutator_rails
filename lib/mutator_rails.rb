# frozen_string_literal: true

require 'etc'
require 'yaml'
require 'json'
require 'ostruct'
require 'fileutils'
require 'rake/file_list'
require 'procto'
require 'adamantium'
require 'concord'
require 'rails'

require 'mutator_rails/guide'
require 'mutator_rails/railtie'
require 'mutator_rails/config'
require 'mutator_rails/version'

require 'mutator_rails/analyze'
require 'mutator_rails/full_mutate'

# Mutator Rails' core functionality
module MutatorRails
  MUTANT_VERSION = `bundle exec mutant --version`.strip.split('-').last.strip

  COMMAND     = 'RAILS_ENV=test bundle exec mutant '
  BASIC_PARMS = ['-r./config/environment.rb', '--use rspec'].freeze

  APP_BASE = 'app/'
end
