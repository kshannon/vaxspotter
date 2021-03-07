class AdminController < ApplicationController
  before_action :authentication_required!

  def index
    @count_appointments = Appointment.all.count()
    @count_locations = Location.all.count()
  end
end
