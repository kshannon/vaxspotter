class FeedController < ApplicationController
  def index
    @valid_locations = Location.joins(:appointments).where(["appointments.date >= ?", Time.now]).group(:id)
    @current_appointments = Appointment.where("date >= ?", Time.now).order("date DESC")
  end
end