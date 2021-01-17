# frozen_string_literal: true

module CalendarEvents
  module Services
    class UserAvailability
      attr_reader :user_name, :opts, :start_time, :end_time

      AVAILABLE_STATUS = 'Available'
      NOT_AVAILABLE_STATUS = 'Not Available'

      def initialize(opts = {})
        @user_name = opts[:user_name]
        @opts = opts
        @start_time = opts[:start_time]
        @end_time = calculate_end_time
      end

      def status
        user.overlapping_events(start_time, end_time).present? ? NOT_AVAILABLE_STATUS : AVAILABLE_STATUS
      end

      private

      def user
        @user ||= User.where(user_name: user_name).last
      end

      def calculate_end_time
        if opts[:end_time] == ''
          Time.zone.parse(opts[:start_time]) + 2.hours
        else
          opts[:end_time]
        end
      end
    end
  end
end
