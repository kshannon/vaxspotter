class LocationsController < ApplicationController
  before_action :set_location, only: [:edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to locations_path, notice: "Successfully Added A New Location"
    else
      render :new
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path, notice: "Successfully Deleted The Location"
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: "Successfully Edited The Location"
    else
      render :edit
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :city, :appointment_url, :managed_by, :contact_email, :contact_phone, :is_walk_thru, :is_drive_thru, :location_type)
  end

  def set_location
    @location = Location.find(params[:id])
  end
end