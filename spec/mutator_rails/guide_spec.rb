# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::Guide do
  let(:object) { described_class.new }
  let(:guide_file) { 'log/mutant/guide.txt' }
  let(:log) { 'log/mutant/models/test.log'}
  let(:code_md5) { Digest::MD5.hexdigest('abc') }
  let(:spec_md5) { Digest::MD5.hexdigest('def') }
  before do
    File.delete(guide_file)
  end

  describe '#current?' do
    it 'processes the log files' do
      expect(object.current?(log, code_md5, spec_md5)).to be false

      object.update(log, code_md5, spec_md5)

      expect(object.current?(log, code_md5, spec_md5)).to be true
    end
  end

  describe '#update' do
    it 'processes the log files' do
      object.update(log, code_md5, spec_md5)

      content = File.read(guide_file)
      expect(content).to match("#{log} | #{code_md5} | #{spec_md5} | #{MutatorRails::MUTANT_VERSION}")
    end
  end
end
