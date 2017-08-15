# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::Cleanup do
  let(:object) { described_class.call }

  describe '#call' do
    it 'processes the all code' do
      object
    end
  end
end
