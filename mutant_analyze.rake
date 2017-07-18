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

        # puts content
        # puts target_log
        begin
          inc     = '=HYPERLINK("file://' + Rails.root.join(target_log).to_s + '")'
          alive   = content.match(/Alive:.+?(\d+)$/)[1]
          kills   = content.match(/Kills:.+?(\d+)$/)[1]
          runtime = content.match(/Runtime:\s+?(.+)s/)[1]
          runtime = runtime.to_f rescue 0.0

          total             = alive.to_i + kills.to_i
          pct               = total > 0 ? 100.0 * kills.to_f / total : 100
          mutations_per_sec = runtime > 0 ? total.to_f / runtime : 0

          list << [inc,
                   kills,
                   alive,
                   total,
                   pct,
                   mutations_per_sec,
                   runtime]
        rescue
        end
      end
      list = list.sort_by { |a| a[4] }.map { |a| a.join("\t") }

      File.write('log/mutant/analysis.tsv',
                 head + list.join("\n"))
    end
  end
end
