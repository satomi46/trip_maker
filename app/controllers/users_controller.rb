class UsersController < ApplicationController
  def show
    redirect_to root_path unless user_signed_in? && current_user.id == params[:id].to_i
  end
end
