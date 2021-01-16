# frozen_string_literal: true

module Importers
  module Users
    class Record
      include ActiveModel::Validations

      module HeaderNames
        USERNAME = 'username'
        EMAIL = 'email'
        PHONE = 'phone'
      end

      HEADERS = [
        HeaderNames::USERNAME,
        HeaderNames::EMAIL,
        HeaderNames::PHONE
      ].freeze

      validate :header_to_be_valid, if: :header?

      attr_reader :row, :opts

      def initialize(row, opts = {})
        @row = row
        @opts = opts
      end

      def process
        return false unless valid?

        upsert_user
      end

      private

      def upsert_user
        user ? update_user : create_user
      end

      def user
        @user ||= User.where(user_name: user_name).last
      end

      def update_user
        user.update_attributes!(email: email, mobile_number: mobile_number)
      end

      def create_user
        User.create!(
          user_name: user_name,
          email: email,
          mobile_number: mobile_number
        )
      end

      def user_name
        @user_name ||= row[HeaderNames::USERNAME].strip
      end

      def email
        @email ||= row[HeaderNames::EMAIL].strip
      end

      def mobile_number
        @mobile_number ||= row[HeaderNames::PHONE].strip
      end

      def header_to_be_valid
        return unless header? && row.sort != HEADERS.sort

        invalid_headers = row - (HEADERS & row)
        errors.add(:base, "invalid headers - #{invalid_headers.join(', ')}")
      end

      def header?
        opts[:header]
      end
    end
  end
end
