# frozen_string_literal: true

require 'csv'
module Importers
  class Processor
    include ActiveModel::Validations

    attr_reader :file_path

    validates :rows, presence: true
    validate :header_row_to_be_valid, if: :rows

    def initialize(file_path)
      @file_path = file_path
    end

    def process
      return false unless valid?

      rows.each_with_index do |row, idx|
        record = record_klass.new(row)
        unless record.process
          errors.add(:base, error_message(record, idx + 1))
          next
        end
      end
      errors.full_messages.present? ? false : true
    end

    def raw_data
      @raw_data ||= File.read(file_path)
    end

    def rows
      @rows ||=
        begin
          CSV.parse(raw_data, headers: true)
        rescue ArgumentError
          nil
        end
    end

    def header_row_to_be_valid
      record = record_klass.new(header_row, header: true)
      return if record.valid?

      errors.add(:base, record.errors.full_messages.join(', '))
    end

    def header_row
      @header_row ||= rows.headers
    end

    def error_message(record, row_number)
      "Row #{row_number}: #{record.errors.full_messages.join(', ')}"
    end
  end
end
