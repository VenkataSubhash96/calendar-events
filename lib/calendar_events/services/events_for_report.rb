# frozen_string_literal: true

module CalendarEvents
  module Services
    class EventsForReport
      attr_reader :from_date, :to_date

      def initialize(opts = {})
        @from_date = opts[:from_date] || Date.today.beginning_of_day
        @to_date = opts[:to_date] || Date.today.end_of_day
      end

      def fetch
        Event.where('start_time >= ?', from_date)
             .where('end_time <= ?', to_date)
      end
    end
  end
end
