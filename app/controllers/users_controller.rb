class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: User.all
  end

  def show
    render json: current_user
  end

  def update
    if current_user.update!(user_params)
      render json: current_user
    else
      render json: current_user.error_messages
    end
  end

  private
  def user_params
    params.permit(:latitude, :longitude)
  end
end
