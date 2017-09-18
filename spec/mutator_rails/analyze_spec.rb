# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::Analyze do
  let(:object) { described_class.call }
  let(:analysis_file) { 'log/mutant/analysis.tsv' }
  before do
    File.delete(analysis_file) if File.exist?(analysis_file)
  end

  describe '#call' do
    it 'processes the log files' do
      object

      expect(File.exist?(analysis_file)).to be true
    end

    it 'has the correct number of lines' do
      object
      analysis = File.read(analysis_file)

      expect(analysis.split("\n")).to have(3).lines
    end
  end
end
