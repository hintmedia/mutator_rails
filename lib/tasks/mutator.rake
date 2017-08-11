# frozen_string_literal: true

require 'etc'
require 'yaml'
require 'json'
require 'ostruct'
require 'fileutils'

if Rails.env.development? || Rails.env.test?

  namespace :mutator do
    desc 'Run whole mutation process'
    task all: %i[files analyze] do
      puts 'all processed!'
    end
  end
end
