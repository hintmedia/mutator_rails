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
      [inc, kills, alive, total, pct, mutations_per_sec].join("\t")
    end

    private

    attr_reader :content

    def alive
      content.match(/Alive:.+?(\d+)$/)[1]
    end

    def absolute_file_path
      File.expand_path(File.join(File.dirname(target_log), target_log)).to_s
    end

    def inc
      "=HYPERLINK(\"file://#{absolute_file_path}\")"
    end

    def kills
      content.match(/Kills:.+?(\d+)$/)[1]
    end

    def mutations_per_sec
      return 0 unless runtime.positive?

      total.to_f / runtime
    end

    def pct
      return 100 unless total.positive?

      (100.0 * kills.to_f) / total
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
