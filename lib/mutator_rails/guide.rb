# frozen_string_literal: true

module MutatorRails
  class Guide

    SEP = ' | '.freeze

    def initialize(*)
      preset_file
    end

    def current?(log, code_md5, spec_md5)
      File.exist?(log) &&
        File.size(log).positive?
        guides[log].present? &&
        guides[log].eql?([code_md5, spec_md5, MUTANT_VERSION])
    end

    def update(log, code_md5, spec_md5)
      guides[log] = [code_md5, spec_md5, MUTANT_VERSION]
      recreate
    end

    private

    def preset_file
      create_guide_file unless File.exist?(guide_file_name)

      load
    end

    def load
      @guides = {}
      f       = File.new(guide_file_name)
      f.readlines do |line|
        log, code_md5, spec_md5, mutant_version = line.split(SEP)
        guides[log]                             = [code_md5, spec_md5, mutant_version]
      end

    end

    def recreate
      f = File.open(guide_file_name, 'w')
      guides.sort.each do |k, v|
        f.write(k + SEP + v.join(SEP))
      end
      f.close
    end

    def create_guide_file
      puts ".. creating guide file #{guide_file_name}"
      File.open(guide_file_name, "w+")
    end

    def guide_file_name
      Pathname(Dir.pwd).join(MutatorRails::Config.configuration.guide_file).tap do |p|
        FileUtils.mkdir_p(p.dirname)
      end
    end

    attr_reader :guides
  end
end
