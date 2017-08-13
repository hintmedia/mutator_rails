# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MutatorRails::SingleMutate do
  let(:file) { 'app/models/test.rb' }
  let(:guide) { MutatorRails::Guide.new }
  let(:object) { described_class.new(guide, file) }

  describe '#call' do
    it 'processes the all code' do
      object.call
    end
  end

  describe '#old_log' do
    it 'returns old log file name (deprecated name)' do
      expect(object.old_log)
        .to eql('log/mutant/models/test_fdef5a515ce8eff897a72b026aadbaba_0e7f4802f58bbbb186be8b44a74a33e3_0.8.14.log')
    end
  end

  describe '#log_location' do
    it 'returns log file' do
      expect(object.log_location.to_s)
        .to eql('log/mutant/models/test')
    end
  end

  describe '#full_log' do
    it 'returns full log file name' do
      expect(object.full_log.to_s)
        .to eql('log/mutant/models/test.log')
    end
  end

  describe '#log' do
    it 'returns log file' do
      expect(object.log.to_s)
        .to eql('log/mutant/models/test.log')
    end
  end

  describe '#log_dir' do
    it 'returns log file dir' do
      expect(object.log_dir.to_s).to eql('log/mutant/models')
    end
  end
  
  describe '#spec_md5' do
    it 'returns md5 hash of spec file' do
      expect(object.spec_md5)
        .to eql('0e7f4802f58bbbb186be8b44a74a33e3')
    end
  end

  describe '#path' do
    it 'returns path to code' do
      expect(object.path)
        .to be_an_instance_of(Pathname)
    end
  end

  describe '#rerun' do
    let(:cmd) { 'command' }
    it 'returns nothing - no rerun' do
      expect(object.rerun(cmd)).to be_nil
    end
  end

  describe '#first_run' do
    let(:parms) { %w[a b] }
    it 'returns first run results cmd' do
      expect(object.first_run(parms))
        .to eql('SPEC_OPTS="--pattern spec/models/test_spec.rb" RAILS_ENV=test bundle exec mutant a b')
    end
  end

  describe '#spec_opt' do
    it 'returns spec option string' do
      expect(object.spec_opt)
        .to eql('SPEC_OPTS="--pattern spec/models/test_spec.rb" ')
    end
  end

  describe '#spec_file' do
    it 'returns spec_file name' do
      expect(object.spec_file)
        .to eql('spec/models/test_spec.rb')
    end
  end

  describe '#complete?' do
    let(:log) { 'log/mutant/models/test.log' }
    it 'returns completion indication' do
      expect(object.complete?(log)).to be true
    end
  end

  describe '#preface' do
    let(:base) { 'abc' }
    it 'returns preface' do
      expect(object.preface(base)).to eql('')
    end
  end
end
