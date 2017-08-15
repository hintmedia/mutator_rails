# frozen_string_literal: true

require 'mutator_rails/single_mutate'

module MutatorRails
  class Cleanup
    include Procto.call
    include Adamantium::Flat

    def initialize(*)
      excluded_files
      @guide = Guide.new
      @guide_keys = guide.guides.keys
    end

    def call
      Dir
        .glob(APP_BASE + '**/*.rb') 
        .each do |file|
        next if exclude?(file)

        check(file)
      end

      guide_keys.each do |file|
        File.delete(file) if File.exist?(file)
        puts "removing #{file}"
        guide.remove(file)
      end
    end

    private
    
    def check(file)
      log = file.sub(APP_BASE, Config.configuration.logroot).sub('.rb','.log')

      if guide_keys.include?(log)
        guide_keys.delete(log)
      end
    end

    def excluded_files
      @exclusions ||= load_exclusions
    end

    def load_exclusions
      MutatorRails::Config
        .configuration
        .exclusions
        .compact
        .flat_map { |exclusion| Dir.glob(exclusion) }
    end

    def exclude?(file)
      excluded_files.include?(file)
    end

    attr_reader :guide_keys, :guide
  end
end
