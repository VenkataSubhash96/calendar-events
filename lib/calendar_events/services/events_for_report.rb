# frozen_string_literal: true

module CalendarEvents
  module Services
    class EventsForReport
      attr_reader :start_time, :end_time

      def initialize(opts = {})
        @start_time = opts[:start_time] || Date.today.beginning_of_day
        @end_time = opts[:end_time] || Date.today.end_of_day
      end

      def fetch
        Event.where('start_time >= ?', parsed_start_time)
             .where('end_time <= ?', parsed_end_time)
      end

      private

      def parsed_start_time
        @parsed_start_time ||= Time.zone.parse(start_time.to_s)
      end

      def parsed_end_time
        @parsed_end_time ||= Time.zone.parse(end_time.to_s)
      end
    end
  end
end
