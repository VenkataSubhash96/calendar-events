# frozen_string_literal: true

module Importers
  module Events
    class Record
      include ActiveModel::Validations

      module HeaderNames
        TITLE = 'title'
        STARTTIME = 'starttime'
        ENDTIME = 'endtime'
        DESCRIPTION = 'description'
        RSVP = 'users#rsvp'
        ALLDAY = 'allday'
      end

      module AllDayValues
        TRUE = 'true'
        FALSE = 'false'
      end

      HEADERS = [
        HeaderNames::TITLE,
        HeaderNames::STARTTIME,
        HeaderNames::ENDTIME,
        HeaderNames::DESCRIPTION,
        HeaderNames::RSVP,
        HeaderNames::ALLDAY
      ].freeze

      EVENT_REJECTION_NOTES = 'Busy with another meeting'

      validate :header_to_be_valid, if: :header?

      attr_reader :row, :opts

      def initialize(row, opts = {})
        @row = row
        @opts = opts
      end

      def process
        return false unless valid?

        create_event
        create_attendants
      end

      private

      def create_event
        @event = ::Event.create!(
          title: title,
          start_time: parsed_start_time,
          end_time: parsed_end_time,
          description: description,
          status: event_status,
          all_day: boolean_value(all_day)
        )
      end

      def create_attendants
        return true unless users_rsvp

        users_rsvp_details.each do |user_rspv_detail|
          user = fetch_user(user_rspv_detail[:user_name])
          next unless user

          rspv_status = user_rspv_detail[:status]
          if rspv_status == ::Attendant::Statuses::YES
            existing_user_events(user.id).update_all(
              status: ::Attendant::Statuses::NO,
              notes: EVENT_REJECTION_NOTES,
              updated_at: Time.zone.now
            )
          end
          Attendant.create!(
            user_id: user.id,
            event_id: @event.id,
            status: rspv_status
          )
        end
      end

      def existing_user_events(user_id)
        ::Attendant.where(
          user_id: user_id,
          status: ::Attendant::Statuses::YES
        )
      end

      def fetch_user(user_name)
        User.where(user_name: user_name).last
      end

      def event_status
        return ::Event::Statuses::IN_PROGRESS if boolean_value(all_day)
        return ::Event::Statuses::UPCOMING if parsed_start_time > current_time
        return ::Event::Statuses::COMPLETED if parsed_end_time < current_time

        ::Event::Statuses::IN_PROGRESS
      end

      def users_rsvp_details
        @users_rsvp_details ||=
          users_rsvp.split(';').map { |user_rspv| user_rspv.split('#') }.map do |details|
            {
              user_name: details[0],
              status: details[1]
            }
          end
      end

      def parsed_start_time
        @parsed_start_time ||= Time.zone.parse(start_time)
      end

      def parsed_end_time
        @parsed_end_time ||= Time.zone.parse(end_time)
      end

      def title
        @title ||= row[HeaderNames::TITLE].strip
      end

      def start_time
        @start_time ||= row[HeaderNames::STARTTIME].strip
      end

      def end_time
        @end_time ||= row[HeaderNames::ENDTIME].strip
      end

      def description
        @description ||= row[HeaderNames::DESCRIPTION].strip
      end

      def all_day
        @all_day ||= row[HeaderNames::ALLDAY].strip
      end

      def users_rsvp
        @users_rsvp ||= row[HeaderNames::RSVP].try(:strip)
      end

      def current_time
        @current_time ||= Time.zone.now
      end

      def header_to_be_valid
        return unless header? && row.sort != HEADERS.sort

        invalid_headers = row - (HEADERS & row)
        errors.add(:base, "invalid headers - #{invalid_headers.join(', ')}")
      end

      def header?
        opts[:header]
      end

      def boolean_value(value)
        if value.downcase == AllDayValues::TRUE.downcase
          true
        elsif value.downcase == AllDayValues::FALSE.downcase
          false
        end
      end
    end
  end
end
