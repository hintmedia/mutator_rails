# frozen_string_literal: true

require 'mutator_rails/single_mutate'

module MutatorRails
  class FullMutate
    include Procto.call
    include Adamantium::Flat

    def initialize(*)
      excluded_files
    end

    def call
      Dir.glob(APP_BASE + '**/*.rb').sort_by { |x| File.size(x) }.each do |file|
        next if exclude?(file)

        SingleMutate.new(file).call
      end
    end

    private

    def excluded_files
      @exclusions ||= load_exclusions
    end

    def load_exclusions
      MutatorRails::Config.configuration.exclusions.compact.flat_map { |exclusion| Dir.glob(exclusion) }
    end

    def exclude?(file)
      excluded_files.include?(file)
    end
  end
end
