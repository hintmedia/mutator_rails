# frozen_string_literal: true

class MutationLog

  include Adamantium::Flat
  include Concord.new(:target_log, :content)

  HEADER = ['log',
            'kills',
            'alive',
            'total',
            'pct killed',
            'mutations per sec',
            'runtime'].join("\t") + "\n".freeze

  def to_s
    [inc, kills, alive, total, pct, mutations_per_sec].join("\t")
  end

  private

  def inc
    '=HYPERLINK("file://' + Rails.root.join(target_log).to_s + '")'
  end

  def alive
    content.match(/Alive:.+?(\d+)$/)[1]
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

  def <=> (other)
    self.pct <=> other.pct
  end
end
