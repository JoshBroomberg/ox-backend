class Game < ActiveRecord::Base
  has_many :user_games
  has_many :users, through: :user_games

  after_create :setup_board
  #after_save :check_win

  validates_length_of :board, maximum: 9, minimum: 9, allow_blank: true

  enum state: [
    :open,
    :expired,
    :tied,
    :won
  ]
  
  def to_json

    # Jbuilder.new do |game|
    #   game.board board
    #   game.state state
    #   game.player_one player_one
    #   game.player_two player_two
    # end.target!
    {
      board: board,
      state: state,
      player_one: player_one,
      player_two: player_two
    }
  end

  def player_one
    user_games.where(player_one: true).first.try(:user)
  end

  def player_two
    user_games.where(player_one: false).first.try(:user)
  end

  private 

  def setup_board
    self.update!(board: "_________")
  end

  def board_array
    board.split("")
  end
end
