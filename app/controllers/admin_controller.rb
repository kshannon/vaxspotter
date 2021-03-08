class AdminController < ApplicationController
  # before_action :authenticate_user!

  def index
    @count_appointments = Appointment.all.count()
    @count_locations = Location.all.count()
  end
end
