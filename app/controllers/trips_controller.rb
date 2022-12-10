class TripsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :move_to_index, only: :new
  before_action :move_to_index_unless_own_page, only: :edit

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

  def edit
    @trip = Trip.find(params[:id])
  end
  
  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end

  def destroy
    trip = Trip.find(params[:id])
    trip.destroy
    redirect_to user_path(current_user.id)
  end

  private

  def trip_params
    params.require(:trip).permit(:image, :title, :start_date, :end_date, user_ids: [])
  end

  def move_to_index
    redirect_to root_path unless user_signed_in?
  end

  def move_to_index_unless_own_page
    redirect_to root_path unless user_signed_in? && Trip.find(params[:id]).user_ids.include?(current_user.id)
  end
end
