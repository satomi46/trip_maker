class FixedTripsController < ApplicationController
  def new
    @fixed_trip = FixedTrip.new
    @trip = Trip.find(params[:trip_id])
    @details = @trip.details.order('time ASC')
  end

  def create
    fixed_trip_params[:detail_ids].each do |detail_id|
      fixed_trip = FixedTrip.new(trip_id: params[:trip_id], detail_id: detail_id)
      fixed_trip.save
    end
    redirect_to root_path
  end

  def delete
  end

  private

  def fixed_trip_params
    params.require(:fixed_trip).permit(detail_ids: []).merge(trip_id: params[:trip_id])
  end

end
