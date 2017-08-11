# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::SingleMutate do
  let(:file) { 'app/models/test.rb' }
  let(:object) { described_class.new(file) }

  describe '#call' do
    it 'processes the all code' do
      object.call
    end
  end

  describe '#log' do
    it 'returns log file' do
      expect(object.log)
        .to eql('log/mutant/models/test_5b59da4c36de3f99b9bb689e984f6b5b_0e7f4802f58bbbb186be8b44a74a33e3_0.8.14.log')
    end
  end

  describe '#log_location' do
    it 'returns log file' do
      expect(object.log_location.to_s)
        .to eql('log/mutant/models/test_')
    end
  end
  describe '#log_dir' do
    it 'returns log file' do
      expect(object.log_dir.to_s).to eql('log/mutant/models')
    end
  end
  describe '#md5_spec' do
    it 'returns md5 hash of spec file' do
      expect(object.md5_spec).to eql('0e7f4802f58bbbb186be8b44a74a33e3')
    end
  end

  describe '#path' do
    it 'returns log file' do
      expect(object.path)
        .to be_an_instance_of(Pathname)
    end
  end

  describe '#rerun' do
    let(:cmd) { 'command' }
    it 'returns log file' do
      expect(object.rerun(cmd)).to be_nil
    end
  end

  describe '#first_run' do
    let(:parms) { ['a', 'b'] }
    it 'returns log file' do
      expect(object.first_run(parms)).to eql('SPEC_OPTS="--pattern spec/models/test_spec.rb" RAILS_ENV=test bundle exec mutant a b')
    end
  end

  describe '#spec_opt' do
    it 'returns log file' do
      expect(object.spec_opt).to eql('SPEC_OPTS="--pattern spec/models/test_spec.rb" ')
    end
  end

  describe '#spec_file' do
    it 'returns log file' do
      expect(object.spec_file).to eql('spec/models/test_spec.rb')
    end
  end

  describe '#exclude_file?' do
    it 'returns log file' do
      expect(object.exclude_file?).to be false
    end
  end

  describe '#complete?' do
    let(:log) { 'spec/test.log' }
    it 'returns log file' do
      expect(object.complete?(log)).to be true
    end
  end

  describe '#preface' do
    let(:base) { 'abc' }
    it 'returns log file' do
      expect(object.preface(base)).to eql('')
    end
  end
end
