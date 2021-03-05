class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:edit, :update, :destroy]

  def index
    @appointments = Appointment.all.order("date DESC")
  end

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      redirect_to appointments_path, notice: "Successfully Added A New appointment"
    else
      render :new
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Successfully Deleted The appointment"
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: "Successfully Edited The appointment"
    else
      render :edit
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:location_id, :date, :start_time, :end_time, :vaccines_available)
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end
end