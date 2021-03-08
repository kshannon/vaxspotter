class FeedController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @valid_locations = Location.joins(:appointments).where(["appointments.date >= ?", Time.now]).group(:id)
    @current_appointments = Appointment.where("date >= ?", Time.now).order("date DESC")
    if Appointment.exists?
      updated = Appointment.order("created_at").last.created_at.strftime("%m/%d @ %I:%M %p")
      @last_updated = "Last Updated: #{updated}"
    else
      @last_updated = "No Updates Yet."
    end
  end
end