# frozen_string_literal: true

module MutatorRails
  class MutationLog
    include Adamantium::Flat
    include Concord.new(:target_log)

    HEADER = (['log',
               'kills',
               'alive',
               'total',
               'pct killed',
               'mutations per sec',
               'runtime'].join("\t") + "\n").freeze

    def initialize(*)
      super

      @content = File.read(target_log)
    end

    def to_s
      return '' unless complete?

      [link, kills, alive, total, pct, mutations_per_sec, runtime].join("\t")
    rescue
      ''
    end

    def complete?
      /^Subjects: / === content
    end

    def details
      [klass, kills, alive, total, pct, mutations_per_sec, runtime, failure, j1]
    rescue
      []
    end

    def pct
      return 100 unless total.positive?

      ((100.0 * kills.to_f) / total).round(3)
    end

    def alive
      content.match(/Alive:.+?(\d+)$/)[1].to_i rescue 0
    end

    def j1
      content.match(/Jobs:.+?(\d+)$/)[1].to_i.eql(1) rescue false
    end

    def link
      "=HYPERLINK(\"#{relative_path}\",\"#{klass}\")"
    end

    private

    attr_reader :content

    def relative_path
      absolute_file_path.relative_path_from(csv_file)
    end

    def csv_file
      Pathname(File.dirname(Pathname(csv))).realpath
    end

    def csv
      MutatorRails::Config.configuration.analysis_csv
    end

    def klass
      k = content.match(/match_expressions: \[(.+?)\]>$/)
      k ? k[1] : ''
    end

    def failure
      /Failures:/ === content
    end

    def absolute_file_path
      Pathname(target_log).realpath
    end

    def kills
      content.match(/Kills:.+?(\d+)$/)[1] rescue 0
    end

    def mutations_per_sec
      return 0 unless runtime.positive?

      (total.to_f / runtime).round(3)
    end


    def runtime
      content.match(/Runtime:\s+?(.+)s/).captures.first.to_f
    rescue
      0.0
    end

    def total
      alive.to_i + kills.to_i
    end

    def <=>(other)
      [pct, -alive, link] <=> [other.pct, -other.alive, other.link]
    end
  end
end
