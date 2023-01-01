class FixedTripsController < ApplicationController
  def new
    @fixed_trip = FixedTrip.new
    @trip = Trip.find(params[:trip_id])
    @details = @trip.details.order('time ASC')
  end

  def create
  end

  def delete
  end
end
