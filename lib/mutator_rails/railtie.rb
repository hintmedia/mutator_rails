# frozen_string_literal: true

require 'mutator_rails'
require 'rails'

module MutatorRails
  class Railtie < Rails::Railtie
    railtie_name :mutator_rails

    rake_tasks do
      load 'tasks/mutator/mutator.rake'
      load 'tasks/mutator/analyze.rake'
      load 'tasks/mutator/statistics.rake'
      load 'tasks/mutator/cleanup.rake'
      load 'tasks/mutator/mutate_files.rake'
    end
  end
end
