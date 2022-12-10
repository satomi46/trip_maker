class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :move_to_index, only: :show

  def show
    user = User.find(params[:id])
    @nickname = user.nickname
    # @trips = user.trips
    @trips = Trip.where(id: user.trip_ids)
  end
  
  private
  def move_to_index
    redirect_to root_path unless current_user.id == params[:id].to_i
  end
end
