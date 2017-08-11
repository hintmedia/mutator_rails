# frozen_string_literal: true

module MutatorRails
  class FullMutate
    def call
      FileList.new(APP_BASE + '**/*.rb').sort_by { |x| File.size(x) }.each do |file|
        SingleMutate.call(file)
      end
    end
  end
end
