# frozen_string_literal: true

require 'mutator_rails/single_mutate'

module MutatorRails
  class FullMutate
    include Procto.call
    include Adamantium::Flat

    def initialize(*)
      excluded_files
      @guide = Guide.new
    end

    def call
      process(all_files)
    end

    def unprocessed
      process(unprocessed_files)
    end

    private

    def unprocessed_files
      all_files.select do |file|
        sm = SingleMutate.new(guide, file)
        !exclude?(file) && !guide.log_exists?(sm.log)
      end
    end

    def process(files)
      files.sort_by { |x| File.size(x) }.each do |file|
        next if exclude?(file)

        SingleMutate.new(guide, file).call
      end
    end

    def all_files
      Dir.glob(APP_BASE + '**/*.rb')
    end

    def excluded_files
      @exclusions ||= load_exclusions
    end

    def load_exclusions
      MutatorRails::Config.configuration
        .exclusions
        .compact
        .flat_map { |exclusion| Dir.glob(exclusion) }
    end

    def exclude?(file)
      excluded_files.include?(file)
    end

    attr_reader :guide
  end
end
