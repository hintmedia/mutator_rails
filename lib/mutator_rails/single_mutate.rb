# frozen_string_literal: true

module MutatorRails
  class SingleMutate
    include Concord.new(:file)

    def call
      parms = BASIC_PARMS.dup
      parms << preface(path.basename) + base

      parms << '> ' + log

      cmd = first_run(parms)
      rerun(cmd)
    end

    def log
      "#{log_location}#{md5}_#{md5_spec}_#{MUTANT_VERSION}.log"
    end

    def log_location
      path.sub(APP_BASE, logroot).sub('.rb', '_')
    end

    def log_dir
      log_location.dirname.tap do |dir|
        FileUtils.mkdir_p(dir)
      end
    end

    def md5_spec
      Digest::MD5.file(spec_file).hexdigest
    end

    def base
      path.basename.to_s.sub(path.extname, '').camelize
    end

    def md5
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
      `#{cmd2}`
    end

    def first_run(parms)
      cmd = spec_opt + COMMAND + parms.join(' ')

      if Dir.glob(log).empty? || File.size(log).zero? || !complete?(log)
        begin
          File.delete(Dir.glob("#{log_location}*.log").first)
        rescue
          nil
        end

        puts "[#{Time.current.iso8601}] #{cmd}"
        `#{cmd}`
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
      /Kills:/.match?(content)
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
