class GamesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json
  
  def index
    render json: current_user.games.open.map(&:to_json)
  end

  def create
    game = Game.create!
    user_game = UserGame.create(
      user: current_user,
      game: game,
      player_one: true
    )
    render json: game.to_json
  end
end
