# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Analyze
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
      return if list.blank?

      content = list.sort.map(&:to_s).join("\n")

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
