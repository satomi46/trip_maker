class TripsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_action :move_to_index, only: :new

  def index
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:image, :title, :start_date, :end_date, user_ids: [])
  end

  def move_to_index
    redirect_to root_path unless user_signed_in?
  end
end
