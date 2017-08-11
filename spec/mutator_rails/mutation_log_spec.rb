# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::MutationLog do
  let(:log) { 'spec/test.log' }
  let(:object) { described_class.new(log) }

  describe '#call' do
    let(:expectation) { '\t73\t26\t99\t73.737\t1.559\t63.52' }
    subject { object.to_s }
    it 'processes the all code' do
      expect(subject).to match(expectation)
      expect(subject).to match('HYPERLINK')
      expect(subject).to match('"Export::ActivityExporter"')
    end
  end
end
