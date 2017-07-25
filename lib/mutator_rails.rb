# frozen_string_literal: true

require 'mutator_rails/version'

module MutatorRails
  Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)
end
