# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Analyze
    include Procto.call
    include Adamantium::Flat

    def call
      list = ListMaker.new.make_list
      return if list.blank?

      content = list.map(&:to_s).join("\n")

      puts " ... storing #{csv}"
      File.write(csv,
                 MutationLog::HEADER + content)
    end

    private

    def csv
      MutatorRails::Config.configuration.analysis_csv
    end
  end
end
