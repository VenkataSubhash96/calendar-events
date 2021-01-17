class EventsController < ApplicationController
  def index
    @events = CalendarEvents::Services::EventsForReport.new(index_params).fetch
  end

  private

  def index_params
    params.require(:event).permit(:start_time, :end_time)
  end
end
