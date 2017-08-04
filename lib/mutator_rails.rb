# frozen_string_literal: true

require 'mutator_rails/version'

# Mutator Rails' core functionality
module MutatorRails
  require 'mutator_rails/railtie' if defined?(Rails)
end
