class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :move_to_index, only: :show

  def show
    user = User.find(params[:id])
    @nickname = user.nickname
    # 旅行リストのデータ
    fixed_trip_ids = FixedTrip.where(trip_id: user.trip_ids).pluck(:trip_id).uniq
    @fixed_trips = Trip.where(id: fixed_trip_ids)
    @non_fixed_trips = Trip.where(id: user.trip_ids).where.not(id: fixed_trip_ids)
    # フレンドリストのデータ
    @friends = current_user.matchers
    @followers = current_user.followers
    @users = User.where.not(id: current_user.id).page(params[:page]).per(5)
  end

  private

  def move_to_index
    redirect_to root_path unless current_user.id == params[:id].to_i
  end
end
