# frozen_string_literal: true

require 'mutator_rails/single_mutate'

module MutatorRails
  class FullMutate
    include Procto.call
    include Adamantium::Flat

    def call
      Dir.glob(APP_BASE + '**/*.rb').sort_by { |x| File.size(x) }.each do |file|
        SingleMutate.new(file).call
      end
    end
  end
end
