# frozen_string_literal: true

require 'mutator_rails/mutation_log'

module MutatorRails
  class Config

    PROJECT_ROOT   = Pathname.new(__dir__).parent.parent.expand_path.freeze
    CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'mutator_rails.yml').freeze
    USER_CONFIG    = ::Rails.root&.join('mutator_rails.yml').freeze

    private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)

    class << self
      def configuration
        @configuration ||= load_configuration
      end

      def load_configuration
        default_config = YAML.load_file(CONFIG_DEFAULT)
        user_config    = if USER_CONFIG && File.exist?(USER_CONFIG)
                           puts "user config discovered"
                           puts USER_CONFIG
                           YAML.load_file(USER_CONFIG)
                         else
                           puts "No user config found"
                           puts PROJECT_ROOT
                           puts CONFIG_DEFAULT
                           {}
                         end

        p default_config
        p user_config

        consolidated = default_config.merge(user_config)

        JSON.parse(consolidated.to_json, object_class: OpenStruct).freeze
      end

    end
  end
end
