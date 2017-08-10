module MutatorRails
  class SingleMutate
    include Concord.new(file)

    def call
      return if exclude_file?

      parms = BASIC_PARMS
      parms << preface(file, path.basename) + base

      parms << '> ' + log

      cmd = first_run(log, log_location, parms, spec)
      rerun(cmd, log)
    end

    def log
      "#{log_location}#{md5}_#{md5_spec}_#{MUTANT_VERSION}.log"
    end

    def log_location
      path.sub(APP_BASE, CONFIG.logroot).sub('.rb', '_')
    end

    def log_dir
      path.dirname.sub(APP_BASE, CONFIG.logroot).tap do |dir|
        FileUtils.mkdir_p(dir)
      end
    end

    def md5_spec
      Digest::MD5.file(spec).hexdigest
    end

    def spec
      spec_file(path)
    end

    def base
      path.basename.to_s.gsub(path.extname, '').camelize
    end

    def md5
      Digest::MD5.file(path).hexdigest
    end

    def path
      Pathname.new(file)
    end

    def rerun(cmd, log)
      return unless File.exist?(log)

      content = File.read(log)
      return unless content =~ /Failures:/

      FileUtils.cp(log, '/tmp')
      cmd2 = cmd.sub('--use', '-j1 --use')
      puts log
      puts "[#{Time.current.iso8601}] #{cmd2}"
      `#{cmd2}`
    end

    def first_run(log, log_location, parms, spec)
      cmd = spec_opt(spec) + COMMAND + parms.join(' ')

      if Dir.glob(log).empty? || File.size(log).zero? || !complete?(log)
        File.delete(Dir.glob("#{log_location}*.log").first) rescue nil

        puts "[#{Time.current.iso8601}] #{cmd}"
        `#{cmd}`
      end

      cmd
    end

    def spec_opt(spec)
      "SPEC_OPTS=\"--pattern #{spec}\" "
    end

    def spec_file(path)
      path.sub(APP_BASE, 'spec/').sub('.rb', '_spec.rb')
    end

    def exclude_file?
      CONFIG.exclusions.detect { |exclusion| file =~ exclusion }.present?
    end

    def complete?(log)
      content = File.read(log)
      /Kills:/.match(content)
    end

    def preface(file, base)
      rest = file.sub(APP_BASE, '').sub(/(lib)\//, '').sub(base.to_s, '')
      return '' if rest == ''

      spec    = spec_file(file)
      content = File.read(spec)
      d       = content.match(/RSpec.describe\s+([^ ,]+)/)
      cs      = d[1].split('::')
      cs.pop
      f = cs.join('::')
      f += '::' if f.present?
      f
    end
  end
end
