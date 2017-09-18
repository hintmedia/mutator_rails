# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::ListMaker do

  let(:object) { described_class.new }

  describe '#make_list' do
    it 'has proper content' do
      result = object.make_list

      expect(result).to have(2).entries
      expect(result.last.link).to eql('=HYPERLINK("models/test2.log","Export::ActivityExporter2")')
    end
  end
end
