class FeedController < ApplicationController
  def index
    @valid_locations = Location.joins(:appointments).where(["appointments.date >= ?", Time.now]).group(:id)
    @current_appointments = Appointment.where("date >= ?", Time.now).order("date DESC")
    @last_updated = Appointment.order("created_at").last.created_at.strftime("%m/%d @ %I:%M %p")
  end
end