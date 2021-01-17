# frozen_string_literal: true

class UsersController < ApplicationController
  def availability
    @users_to_select = User.all.map(&:user_name)
    if availability_params[:availability]
      status =
          CalendarEvents::Services::UserAvailability.new(availability_params[:availability]).status
      @user_availability_details = availability_params[:availability].merge!(status: status)
    end
  end

  private

  def availability_params
    params.permit(availability: %i[user_name start_time end_time])
  end
end
