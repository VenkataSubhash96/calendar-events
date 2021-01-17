# frozen_string_literal: true

class UsersController < ApplicationController
  def availability
    @users_to_select = User.all.map(&:user_name)
    if availability_params[:availability]
      service = CalendarEvents::Services::UserAvailability.new(availability_params[:availability])
      @user_availability_details = {
        user_name: service.user_name,
        start_time: service.start_time,
        end_time: service.end_time,
        status: service.status
      }
    end
  end

  private

  def availability_params
    params.permit(availability: %i[user_name start_time end_time])
  end
end
