# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Statistics
    include Procto.call
    include Adamantium::Flat

    WITH_STATS = true

    def call
      list = []

      Dir.glob(Config.configuration.logroot + '**/*.log').each do |target_log|
        next unless File.exist?(target_log)

        begin
          list << MutationLog.new(target_log, WITH_STATS)
        rescue Exception => se
          # skip it
          puts "Error: #{se}"
        end
      end
      return if list.blank?

      content = list.sort.map(&:to_s).join("\n")

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
