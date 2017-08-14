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
      total_mutations
      fully_mutated
      failures
      fallback_to_j1
      top_10_alive
      top_10_longest
      top_10_total_mutations

      puts " ... storing #{stats_file}"
      puts text
      File.write(stats_file, text)
    end

    private

    def fully_mutated
      stats << ''
      stats << "#{full_mutations} module(s) were fully mutated (#{fully_pct.round(1)}%)"
    end

    def failures
      header = false
      content.each do |detail|
        failure = detail[7]
        if failure
          unless header
            failure_header
            header = true
          end
          stats << detail[0]
        end
      end
    end

    def failure_header
      stats << ''
      stats << "The following modules remain with failures (check log):"
    end

    def fallback_to_j1
      header = false
      content.each do |detail|
        failure = detail[8]
        if failure
          unless header
            j1_header
            header = true
          end
          stats << detail[0]
        end
      end
    end

    def j1_header
      stats << ''
      stats << "The following modules fell back to non-parallel(-j1):"
    end

    def top_10_alive
      stats << ''
      stats << "The following modules had most alive mutations (top 10):"
      content.sort_by { |d| -d[2].to_i }.take(10).each do |detail|
        alive = detail[2]
        if alive.positive?
          stats << " . #{detail[0]} (#{alive})"
        end
      end
    end

    def top_10_longest
      stats << ''
      stats << "The following modules had longest mutation time (top 10):"
      content.sort_by { |d| -d[6].to_i }.take(10).each do |detail|
        time = detail[6]
        if time&.positive?
          stats << " . #{detail[0]} (#{humanize(time.to_i)})"
        end
      end
    end

    def top_10_total_mutations
      stats << ''
      stats << "The following modules had largest mutation count (top 10):"
      content.sort_by { |d| -d[3].to_i }.take(10).each do |detail|
        cnt = detail[3]
        if cnt&.positive?
          stats << " . #{detail[0]} (#{cnt})"
        end
      end
    end

    def text
      stats.join("\n")
    end

    def total_mutations
      stats << ''
      stats << "#{content.size} module(s) were mutated in #{total_mutation_time}"
      stats << "for a total of #{tot_mutations} mutations tested @ #{per_sec.round(2)}/sec average"
      stats << "which left #{total_alive} mutations alive (#{alive_pct.round(1)}%)"
      stats << "and #{total_kills} killed (#{killed_pct.round(1)}%)"
    end

    def full_mutations
      tot = 0
      content.each do |detail|
        alive = detail[2]
        tot   += 1 if alive&.zero?
      end
      tot
    end

    def fully_pct
      100.0 * full_mutations / content.size
    end

    def total_alive
      tot = 0
      content.each do |detail|
        alive = detail[2]
        tot   += alive.to_i
      end
      tot
    end

    def total_mutation_time
      humanize(total_seconds.to_i)
    end

    def total_seconds
      tot = 0.0
      content.each do |detail|
        runtime = detail[6]
        tot     += runtime if runtime
      end
      tot
    end

    def per_sec
      tot_mutations.to_f / total_seconds
    end

    def humanize(secs)
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map { |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{n.to_i.eql?(1) ? name.to_s.chop : name}"
        end
      }.compact.reverse.join(' ')
    end


    def tot_mutations
      tot = 0
      content.each do |detail|
        total = detail[3]
        tot   += total.to_i
      end
      tot
    end

    def total_kills
      tot_mutations - total_alive
    end

    def alive_pct
      100.0 * total_alive / tot_mutations
    end

    def killed_pct
      100.0 * total_kills / tot_mutations
    end

    def stats_file
      MutatorRails::Config.configuration.statistics
    end

    attr_reader :stats, :content
  end
end
