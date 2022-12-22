class DetailsController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])
    @detail_coodinate = DetailCoodinate.new(detail_params)
    if @detail_coodinate.valid?
      @detail_coodinate.save
      make_notice
      redirect_to trip_path(params[:trip_id])
    else
      @trip = Trip.find(params[:trip_id])
      @details = @trip.details
      render 'trips/show'
    end
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @detail = Detail.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @detail = Detail.find(params[:id])
    if @detail.update(detail_params_of_edit)
      if @detail.address != ""
        Coodinate.find_or_create_by(address: @detail.address, latitude: params[:lat], longitude: params[:lng])
      end
      make_notice
      redirect_to trip_path(params[:trip_id])
    else
      @trip = Trip.find(params[:trip_id])
      render 'edit'
    end
  end

  def destroy
    @trip = Trip.find(params[:trip_id])
    detail = Detail.find(params[:id]).destroy
    make_notice
    redirect_to trip_path(params[:trip_id])
  end

  private

  def make_notice
    @trip.user_ids.each do |user_id|
      unless user_id == current_user.id
        Notice.find_or_create_by(user_id: user_id, trip_id: @trip.id)
      end
    end
  end

  def detail_params
    params.require(:detail_coodinate).permit(:title, :note, :address, :time, :time_note, :importance, :url, :fixed)
          .merge(trip_id: params[:trip_id], latitude: params[:lat], longitude: params[:lng])
  end

  def detail_params_of_edit
    params.require(:detail).permit(:title, :note, :address, :time, :time_note, :importance, :url, :fixed)
          .merge(trip_id: params[:trip_id])
  end
end
