# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::Analyze do

  let(:object) { described_class.call }

  describe '#call' do
    it 'processes the log files' do
      object
    end
  end
end
