# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Analyze
    include Procto.call
    include Adamantium::Flat

    def call
      list = []

      Dir.glob(CONFIG.logroot + '**/*.log').each do |target_log|
        next unless File.exist?(target_log)

        begin
          list << MutationLog.new(target_log)
        rescue Exception => se
          # skip it
          puts "Error: #{se}"
        end
      end
      list.compact!
      
      return if list.blank?

      content = list.sort.map(&:to_s).join('\n')

      File.write(CONFIG.analysis_csv, MutationLog::HEADER + content)
    end
  end
end
