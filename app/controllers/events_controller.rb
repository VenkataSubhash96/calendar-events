# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = CalendarEvents::Services::EventsForReport.new(index_params[:event] || {}).fetch
  end

  private

  def index_params
    params.permit(event: %i[start_time end_time])
  end
end
