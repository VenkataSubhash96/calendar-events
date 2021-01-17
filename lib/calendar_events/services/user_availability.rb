# frozen_string_literal: true

module CalendarEvents
  module Services
    class UserAvailability
      attr_reader :user_name, :start_time, :end_time

      AVAILABLE_STATUS = 'Available'
      NOT_AVAILABLE_STATUS = 'Not Available'

      def initialize(opts = {})
        @user_name = opts[:user_name]
        @start_time = opts[:start_time]
        @end_time = opts[:end_time] || @start_time + 2.hours
      end

      def status
        user.overlapping_events(start_time, end_time).present? ? NOT_AVAILABLE_STATUS : AVAILABLE_STATUS
      end

      private

      def user
        @user ||= User.where(user_name: user_name).last
      end
    end
  end
end
