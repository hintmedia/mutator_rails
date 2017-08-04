# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :mutant do

    desc 'Run mutation analysis on the mutant logs'
    task :analyze do

      require 'fileutils'
      list = []

      head = ['log',
              'kills',
              'alive',
              'total',
              'pct killed',
              'mutations per sec',
              'runtime'].join("\t") + "\n"
      FileList.new('log/mutant/**/*.log').each do |target_log|
        next unless File.exist?(target_log)

        content = File.read(target_log)

        begin
          list << MutationLog.new(target_log)
        rescue StandardError => se
          puts "Error: #{se}"
        end
      end
      list = list.sort.map(&:to_s)

      File.write('log/mutant/analysis.tsv',
                 head + list.join('\n'))
    end
  end
end
