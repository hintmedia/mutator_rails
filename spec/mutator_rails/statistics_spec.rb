# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::Statistics do
  let(:object) { described_class.call }
  let(:statistics_file) { 'log/mutant/statistics.txt' }
  before do
    File.delete(statistics_file) if File.exist?(statistics_file)
  end

  describe '#call' do
    it 'processes the log files' do
      object

      expect(File.exist?(statistics_file)).to be true
    end
  end
end
