# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?

  namespace :mutator do
    require Rails.root.join('config/environment.rb')

    desc 'Cleanup stale logs'
    task :cleanup do
      MutatorRails::Cleanup.call
    end
  end
end
