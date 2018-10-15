# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::Statistics do
  let(:object) { described_class.call }
  let(:statistics_file) { 'log/mutant/statistics.txt' }
  before do
    File.delete(statistics_file) if File.exist?(statistics_file)
  end

  describe '#call' do
    let(:expectations) do
      "
2 module(s) were mutated in 2 minutes 7 seconds
for a total of 198 mutations tested @ 1.56/sec average
which left 52 mutations alive (26.3%)
and 146 killed (73.7%)

0 module(s) were fully mutated (0.0%)

The following modules remain with failures (check log):
 . Export::ActivityExporter

The following modules fell back to non-parallel(-j1):
 . Export::ActivityExporter2

The following modules had most alive mutations (top 10):
 . Export::ActivityExporter (26)
 . Export::ActivityExporter2 (26)

The following modules had longest mutation time (top 10):
 . Export::ActivityExporter (1 minute 3 seconds)
 . Export::ActivityExporter2 (1 minute 3 seconds)

The following modules had largest mutation count (top 10):
 . Export::ActivityExporter (99)
 . Export::ActivityExporter2 (99)"
    end

    it 'processes the log files' do
      object

      expect(File.exist?(statistics_file)).to be true
    end

    it 'has the proper stats' do
      object
      stats = File.read(statistics_file)

      expect(stats).to match(expectations)
    end
  end
end
