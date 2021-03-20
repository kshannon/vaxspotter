class FeedController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @valid_locations = Location.joins(:appointments).where("appointments.date >= ?", Time.now).where("is_stale = ?", false).group(:id)
    @current_appointments = Appointment.where("date >= ?", Time.now).where("is_stale = ?", false).order("date DESC")

    @last_24_hour_locations = Location.joins(:appointments).where("appointments.created_at > ?", 24.hours.ago).where("is_stale = ?", true).group(:id)
    @last_24_hour__appointments = Appointment.where("created_at > ?", 24.hours.ago).where("is_stale = ?", true).order("date DESC")

    if Appointment.exists?
      updated = Appointment.order("created_at").last.created_at.strftime("%m/%d @ %I:%M %p")
      @last_updated = "Last Updated: #{updated}"
    else
      @last_updated = "No Updates Yet."
    end
  end
end