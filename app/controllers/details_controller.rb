class DetailsController < ApplicationController
  def create
    @detail = Detail.new(detail_params)
    if @detail.save
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
    @detail = Detail.find(params[:id])
    if @detail.update(detail_params)
      redirect_to trip_path(params[:trip_id])
    else
      @trip = Trip.find(params[:trip_id])
      render 'edit'
    end
  end

  def destroy
    detail = Detail.find(params[:id])
    detail.destroy
    redirect_to trip_path(params[:trip_id])
  end

  private

  def detail_params
    params.require(:detail).permit(:title, :note, :address, :time, :time_note, :importance, :url, :fixed)
          .merge(trip_id: params[:trip_id])
  end
end
