require 'mutator_rails'
require 'rails'

module MutatorRails
  class Railtie < Rails::Railtie
    railtie_name :mutator_rails

    rake_tasks do
      load 'tasks/mutator.rake'
    end
  end
end
