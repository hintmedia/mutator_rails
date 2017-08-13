# frozen_string_literal: true

require 'open3'

module MutatorRails
  class SingleMutate
    include Concord.new(:guide, :file)

    def call
      parms = BASIC_PARMS.dup
      parms << preface(path.basename) + base

      parms << '1> ' + log.to_s
      log_dir

      cmd = first_run(parms)
      rerun(cmd)
    end

    def log
      if File.exist?(old_log)
        # repair - this is one time only
        guide.update(full_log, code_md5, spec_md5)
        File.rename(old_log, full_log)
      end
      
      full_log
    end

    def full_log
      log_location.to_s + '.log'
    end

    def old_log
      "#{log_location}_#{code_md5}_#{spec_md5}_#{MUTANT_VERSION}.log"
    end

    def log_location
      path.sub(APP_BASE, logroot).sub('.rb', '')
    end

    def log_dir
      log_location.dirname.tap do |dir|
        FileUtils.mkdir_p(dir)
      end
    end

    def spec_md5
      Digest::MD5.file(spec_file).hexdigest
    end

    def base
      path.basename.to_s.sub(path.extname, '').camelize
    end

    def code_md5
      Digest::MD5.file(path).hexdigest
    end

    def path
      Pathname.new(file)
    end

    def rerun(cmd)
      return unless File.exist?(log)

      content = File.read(log)
      return unless content.match?(/Failures:/)

      FileUtils.cp(log, '/tmp')
      cmd2 = cmd.sub('--use', '-j1 --use')
      puts log
      puts "[#{Time.current.iso8601}] #{cmd2}"
      `#{cmd2}` unless ENV['RACK_ENV'].eql?('test')
    end

    def first_run(parms)
      cmd = spec_opt + COMMAND + parms.join(' ')

      if !guide.current?(log, code_md5, spec_md5) || !complete?(log)
        puts "[#{Time.current.iso8601}] #{cmd}"
        `#{cmd}` unless ENV['RACK_ENV'].eql?('test')
        guide.update(log, code_md5, spec_md5)
      end

      cmd
    end

    def spec_opt
      "SPEC_OPTS=\"--pattern #{spec_file}\" "
    end

    def spec_file
      file.sub(APP_BASE, 'spec/').sub('.rb', '_spec.rb')
    end

    def complete?(log)
      content = File.read(log)
      /^Subjects: /.match?(content)
    end

    def log_correct?
      guide.current?(log, code_md5, spec_md5)
    end

    def preface(base)
      rest = file.sub(APP_BASE, '').sub(/(lib)\//, '').sub(base.to_s, '')
      return '' if rest == ''

      content = File.read(spec_file)
      d       = content.match(/RSpec.describe\s+([^ ,]+)/)
      cs      = d[1].split('::')
      cs.pop
      f = cs.join('::')
      f += '::' if f.present?
      f
    end

    private

    def logroot
      MutatorRails::Config.configuration.logroot
    end
  end
end
