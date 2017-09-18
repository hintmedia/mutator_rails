# frozen_string_literal: true

require 'mutator_rails/single_mutate'

module MutatorRails
  class ListMaker
    include Adamantium::Flat

    def make_list
      list = []

      Dir.glob(Config.configuration.logroot + '**/*.log').each do |target_log|
        next unless File.exist?(target_log)

        begin
          list << MutationLog.new(target_log)
        rescue Exception => se
          # skip it
          puts "Error: #{se}"
        end
      end
      list.sort
    end
  end
end
