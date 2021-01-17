class EventsController < ApplicationController
  def index
    @events = CalendarEvents::Services::EventsForReport.new(params[:event] || {}).fetch
  end
end
