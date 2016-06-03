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

  def show
    game = Game.find_by(id: params[:id])
    if game
      if game.users.include? current_user
        render json: game.to_json
      else
        render json: {error: "access denied"}, status: 403
      end
    else
      render json: {error: "board not found"}, status: 404
    end
  end
end
