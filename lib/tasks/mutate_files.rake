# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :mutator do
    require Rails.root.join('config/environment.rb')

    desc 'Run mutation tests on the full file set'
    task :files do
      MutatorRails::FullMutate.call
    end
  end
end
