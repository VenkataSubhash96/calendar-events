# frozen_string_literal: true

module Importers
  module Users
    class Processor < Importers::Processor
      private

      def record_klass
        Importers::Users::Record
      end
    end
  end
end
