class GamesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: Game.open.map(&:to_json)
  end
end
