class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :move_to_index, only: :show

  def show
    user = User.find(params[:id])
    @nickname = user.nickname
    # TODO @trips = user.trips こちらでも可。どちらがいいか検討し、不要な記述削除
    @trips = Trip.where(id: user.trip_ids)
    @friends = current_user.matchers
    @users = User.all
  end

  private
  def move_to_index
    redirect_to root_path unless current_user.id == params[:id].to_i
  end
end
