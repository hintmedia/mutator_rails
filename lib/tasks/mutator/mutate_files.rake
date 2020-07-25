# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :mutator do
    require Rails.root.join('config/environment.rb')

    desc 'Run mutation tests on the full file set'
    task :files do
      MutatorRails::FullMutate.call
    end

    desc 'Run mutation tests on the unprocessed file set'
    task :unprocessed_files do
      MutatorRails::FullMutate.new.unprocessed
    end

    desc 'Run mutation tests on the j1 file set'
    task :j1_files do
      MutatorRails::FullMutate.new.j1
    end

    desc 'Run mutation tests on the changed file set'
    task :changed_files do
      MutatorRails::FullMutate.new.changed
    end
  end
end
