# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::MutationLog do
  let(:log) { 'spec/test.log' }
  let(:object) { described_class.new(log) }

  describe '#call' do
    let(:expectation) { '\t73\t26\t99\t73.73737373737374\t1.5585642317380353' }
    subject { object.to_s }
    it 'processes the all code' do
      expect(subject).to match(expectation)
      expect(subject).to match('HYPERLINK')
    end
  end
end
