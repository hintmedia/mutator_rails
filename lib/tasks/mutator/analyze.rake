# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?

  namespace :mutator do
    require Rails.root.join('config/environment.rb')

    desc 'Run mutation analysis on the mutant logs'
    task :analyze do
      MutatorRails::Analyze.call
    end
  end
end
