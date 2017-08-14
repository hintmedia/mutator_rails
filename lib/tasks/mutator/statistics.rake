# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?

  namespace :mutator do
    require Rails.root.join('config/environment.rb')

    desc 'Run mutation statistics on the mutant logs'
    task :statistics do
      MutatorRails::Statistics.call
    end
  end
end
