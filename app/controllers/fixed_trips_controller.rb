class FixedTripsController < ApplicationController
  def new
    @fixed_trip = FixedTrip.new
    @trip = Trip.find(params[:trip_id])
    @details = @trip.details.order('time ASC')
  end

  def create
    if params.include?(:fixed_trip)
      fixed_trip_params[:detail_ids].each do |detail_id|
        fixed_trip = FixedTrip.new(trip_id: params[:trip_id], detail_id: detail_id)
        fixed_trip.save
      end
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "チェックを1つ以上つけてください"
      @fixed_trip = FixedTrip.new
      @trip = Trip.find(params[:trip_id])
      @details = @trip.details.order('time ASC')
      render :new
    end
  end

  def destroy
    fixed_trip_ids = FixedTrip.where(trip_id: params[:trip_id]).pluck(:id)
    fixed_trip_ids.each do |id|
      FixedTrip.find(id).destroy
    end
    redirect_to trip_path(params[:trip_id])
  end

  private

  def fixed_trip_params
    params.require(:fixed_trip).permit(detail_ids: []).merge(trip_id: params[:trip_id])
  end

end
