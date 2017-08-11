# frozen_string_literal: true

require 'mutator_rails'
require 'rails'

module MutatorRails
  class Railtie < Rails::Railtie
    railtie_name :mutator_rails

    initializer "Include your code in the controller" do
      ActiveSupport.on_load(:action_controller) do
        include MutatorRails
      end
    end

    rake_tasks do
      load 'tasks/mutator.rake'
      load 'tasks/analyze.rake'
      load 'tasks/mutate_files.rake'
    end
  end
end
