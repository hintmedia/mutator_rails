# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Statistics
    include Procto.call

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

      @content = list.map(&:details)

      @stats = []

      puts " ... storing #{stats_file}"
      File.write(stats_file, stats.join("\n"))
    end

    private

    def stats_file
      MutatorRails::Config.configuration.statistics
    end

    attr_reader :stats, :content
  end
end
