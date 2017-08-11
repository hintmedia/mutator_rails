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
      [link, kills, alive, total, pct, mutations_per_sec, runtime].join("\t")
    rescue
      ''
    end

    def pct
      return 100 unless total.positive?

      (100.0 * kills.to_f) / total
    end

    private

    attr_reader :content

    def relative_path
      absolute_file_path.relative_path_from(csv_file)
    end

    def csv_file
      Pathname(File.dirname(Pathname(CONFIG.analysis_csv))).realpath
    end

    def alive
      content.match(/Alive:.+?(\d+)$/)[1]
    end

    def klass
      content.match(/match_expressions: \[(.+?)\]>$/)[1]
    end

    def absolute_file_path
      Pathname(target_log).realpath
    end

    def link
      "=HYPERLINK(\"#{relative_path}\",\"#{klass}\")"
    end

    def kills
      content.match(/Kills:.+?(\d+)$/)[1]
    end

    def mutations_per_sec
      return 0 unless runtime.positive?

      total.to_f / runtime
    end


    def runtime
      content.match(/Runtime:\s+?(.+)s/)[1].to_f
    rescue
      0.0
    end

    def total
      alive.to_i + kills.to_i
    end

    def <=>(other)
      pct <=> other.pct
    end
  end
end
