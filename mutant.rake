# frozen_string_literal: true
require 'etc'

if Rails.env.development? || Rails.env.test?

  def rerun(cmd, log, spec)
    if File.exist?(log)
      content = File.read(log)
      if content =~ /Mysql2::Error:/
        FileUtils.cp(log, '/tmp')
        File.write("#{Dir.home}/.rspec", "--pattern '#{spec}'")
        cmd2 = cmd.sub('--use', '-j1 --use')
        puts log
        puts "[#{Time.current.iso8601}] #{cmd2}"
        `#{cmd2}`

      end
    end
  end

  def first_run(log, log_location, parms, spec)
    cmd = 'RAILS_ENV=test bundle exec mutant ' + parms.join(' ')
    if Dir.glob(log).empty? || File.size(log).zero? || !complete?(log)
      File.delete(Dir.glob("#{log_location}*.log").first) rescue nil
      File.write("#{Dir.home}/.rspec", "--pattern '#{spec}'")
      puts "[#{Time.current.iso8601}] #{cmd}"
      `#{cmd}`
    end
    cmd
  end

  def spec_file(path)
    path.sub('app/', 'spec/').sub('.rb', '_spec.rb')
  end

  EXCLUSIONS = [/shared/, /observer/, /rails_admin/, /core_ext/, /one_time_job/].freeze

  def exclude?(file)
    EXCLUSIONS.detect { |exclusion| file =~ exclusion }.present?
  end
  
  namespace :mutant do

    MUTANT_VERSION = `bundle exec mutant --version`.strip.split('-').last

    desc 'Run mutation tests on the full AOT model set'
    task :models do
      require 'fileutils'
      require_relative '../../../config/environment.rb' 

      klasses = ActiveRecord::Base.send(:descendants).map { |k| k.name.to_s }

      begin
        FileList.new('app/models/**/*.rb').sort_by { |x| File.size(x) }.each do |file|
          next if exclude?(file)
          parms = ['-r./config/environment.rb']
          path  = Pathname.new(file)
          md5   = Digest::MD5.file(path).hexdigest
          parms << '--use rspec'
          base = path.basename.to_s.gsub(path.extname, '').camelize
          unless klasses.include?(base)
            base = klasses.detect { |k| base.casecmp(k).zero? }
          end

          if base.present?
            parms << base

            spec         = spec_file(path)
            md5_spec     = Digest::MD5.file(spec).hexdigest
            log_dir      = path.dirname.sub('app/', 'log/mutant/')
            log_location = path.sub('app/', 'log/mutant/').sub('.rb', '_')
            log          = "#{log_location}#{md5}_#{md5_spec}_#{MUTANT_VERSION}.log"
            FileUtils.mkdir_p(log_dir)
            parms << '> ' + log

            cmd = first_run(log, log_location, parms, spec)
            rerun(cmd, log, spec)
          end

        end
      ensure
        File.write("#{Dir.home}/.rspec", '')
      end
    end

    def complete?(log)
      content = File.read(log)
      /Kills:/.match(content)
    end

    def preface(file, base)
      rest = file.sub('app/', '').sub(/(lib)\//, '').sub(base.to_s, '')
      return '' if rest == ''

      spec    = spec_file(file)
      content = File.read(spec)
      d       = content.match(/RSpec.describe\s+([^ ,]+)/)
      cs      = d[1].split('::')
      cs.pop
      f = cs.join('::')
      f += '::' if f.present?
      return f

      sections = rest.split('/')
      if sections.one?
        segment = sections.first
        if segment.size <= 3
          return (segment.upcase + '::').sub('::::', '::')
        end
      end

      (rest.camelize + '::').sub('::::', '::')
    end

    desc 'Run mutation tests on the lib,export,import,... set'
    task :lib do
      require 'fileutils'
      require_relative '../../../config/environment.rb'

      begin
        FileList.new('app/**/*.rb')
          .sort_by { |x| File.size(x) }.each do |file|
          next if file =~ /models/ # skip models
          next if exclude?(file)
          
          parms = ['-r./config/environment.rb']
          path  = Pathname.new(file)
          md5   = Digest::MD5.file(path).hexdigest
          parms << '--use rspec'

          base = path.basename.to_s.sub(path.extname, '').camelize

          if base.present?

            parms << preface(file, path.basename) + base

            spec = spec_file(path)

            md5_spec = Digest::MD5.file(spec).hexdigest

            log_dir      = path.dirname.sub('app/', 'log/mutant/')
            log_location = path.sub('app/', 'log/mutant/').sub('.rb', '_')
            log          = "#{log_location}#{md5}_#{md5_spec}_#{MUTANT_VERSION}.log"
            FileUtils.mkdir_p(log_dir)
            parms << '> ' + log

            cmd = first_run(log, log_location, parms, spec)
            rerun(cmd, log, spec)
          end
        end
      ensure
        File.write("#{Dir.home}/.rspec", '')
      end
    end
  end
end
