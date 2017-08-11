# frozen_string_literal: true

require 'spec_helper'

require_relative '../../app/models/test'

RSpec.describe Test do
  let(:object) { described_class.new }

  describe '#call' do
    it 'processes' do
      object.call
    end
  end
end
