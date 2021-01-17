class EventsController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @events = ::CalendarEvents::Services::EventsForReport.new(
      from_date: params[:from_date],
      to_date: params[:to_date]
    ).fetch
    render component: 'EventsList', props: {
      events: @events,
      index_url: Rails.application.routes.url_helpers.events_index_path
    }
  end
end
