# frozen_string_literal: true

require 'etc'
require 'yaml'
require 'json'
require 'ostruct'
require 'fileutils'

if Rails.env.development? || Rails.env.test?

  namespace :mutator do
    desc 'Run whole mutation process'
    task all: %i[unprocessed_files changed_files j1_files files cleanup analyze statistics] do
      puts 'all processed!'
    end
  end
end
