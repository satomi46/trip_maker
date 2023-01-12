class TripsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :show]
  before_action :move_to_index, only: :new
  before_action :move_to_index_unless_own_page, only: [:edit, :show]

  def index
  end

  def show
    @trip = Trip.find(params[:id])
    @detail_coodinate = DetailCoodinate.new
    # 未確定の場合、@detailsで一括り
    @details = @trip.details.order('time ASC')
    # 確定済みの場合、fixed_detailsとnon_fixed_detailsに分けて表示
    fixed_detail_ids = FixedTrip.where(trip_id: @trip.id).pluck(:detail_id)
    @fixed_details = Detail.where(id: fixed_detail_ids).order('time ASC')
    @non_fixed_details = Detail.where(trip_id: @trip.id).where.not(id: fixed_detail_ids).order('time ASC')

    @coords = Coodinate.all
    gon.coords = @coords
    gon.details = @details

    if Notice.exists?(user_id: current_user.id, trip_id: @trip.id)
      Notice.find_by(user_id: current_user.id, trip_id: @trip.id).destroy
    end
  end

  def new
    @trip = Trip.new
    @friends = current_user.matchers
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      make_notice
      redirect_to root_path
    else
      @friends = current_user.matchers
      render :new
    end
  end

  def edit
    @trip = Trip.find(params[:id])
    @friends = current_user.matchers
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      make_notice
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end

  def destroy
    @trip = Trip.find(params[:id]).destroy
    redirect_to user_path(current_user.id)
  end

  private

  def make_notice
    @trip.user_ids.each do |user_id|
      unless user_id == current_user.id
        Notice.find_or_create_by(user_id: user_id, trip_id: @trip.id)
      end
    end
  end

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
