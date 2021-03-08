class AdminController < ApplicationController

  def index
    @count_appointments = Appointment.all.count()
    @count_locations = Location.all.count()
  end
end
