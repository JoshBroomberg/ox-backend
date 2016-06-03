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
      if game.user_is_player? current_user
        render json: game.to_json
      else
        access_denied
      end
    else
      board_not_found
    end
  end

  def join_game
    game = Game.find_by(id: params[:id])
    if game
      unless game.open?
        access_denied
        return
      end

      if game.user_is_player? current_user
        access_denied
        return
      end

      UserGame.create!(game: game, user: current_user, player_one: false)
      game.update(state: :in_progress)
      render json: game.to_json
    else
      board_not_found
    end
  end

  def update
    game = Game.find_by(id: params[:id])
    if game
      if game.user_is_player? current_user
        game.update!(board: params[:board])
        render json: game.to_json
      else
        access_denied
      end
    else
      board_not_found
    end
  end

  def destroy
    game = Game.find_by(id: params[:id])
    if game
      if game.user_is_player? current_user
        game.update!(state: :abandoned)
        render json: game.to_json
      else
        access_denied
      end
    else
      board_not_found
    end
  end

  private

  def access_denied
    render json: {error: "access denied"}, status: 403
  end

  def board_not_found
    render json: {error: "board not found"}, status: 404
  end
end
