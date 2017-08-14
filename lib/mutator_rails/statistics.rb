# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Statistics
    include Procto.call
    include Adamantium::Flat

    def call
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

      content = list.map(&:details)

      stats = []

      puts " ... storing #{stats_file}"
      File.write(stats,
                 MutationLog::HEADER + content)
    end

    private

    def csv
      MutatorRails::Config.configuration.statistics
    end
  end
end
