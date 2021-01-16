# frozen_string_literal: true

module Importers
  module Events
    class Processor < Importers::Processor
      private

      def record_klass
        Importers::Events::Record
      end
    end
  end
end
