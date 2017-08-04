require 'mutator_rails'
require 'rails'

module MutatorRails
  class Railtie < Rails::Railtie
    railtie_name :mutator_rails

    rake_tasks do
      load 'tasks/mutant.rake'
      load 'tasks/mutant_analyze.rake'
    end
  end
end
