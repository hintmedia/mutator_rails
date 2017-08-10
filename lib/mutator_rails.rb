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
require 'mutator_rails/version'
require 'mutator_rails/railtie'
require 'mutator_rails/analyze'

# Mutator Rails' core functionality
module MutatorRails

  MUTANT_VERSION = `bundle exec mutant --version`.strip.split('-').last

  PROJECT_ROOT   = Pathname.new(__dir__).parent.expand_path.freeze
  CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'mutator_rails.yml').freeze
  CONFIG         = JSON.parse(YAML::load_file(CONFIG_DEFAULT).to_json,
                              object_class: OpenStruct).freeze

  COMMAND     = 'RAILS_ENV=test bundle exec mutant '
  BASIC_PARMS = ['-r./config/environment.rb', '--use rspec']

  APP_BASE = 'app/'

  private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
end
