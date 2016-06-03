class Game < ActiveRecord::Base
  has_many :user_games
  has_many :users, through: :user_games

  after_create :setup_board
  #after_save :check_win

  validates_length_of :board, maximum: 9, minimum: 9, allow_blank: true

  enum state: [
    :open,
    :in_progress,
    :expired,
    :tied,
    :won
  ]
  
  def to_json
    {
      id: id,
      board: board,
      state: state,
      host_user: player_one,
      guest_user: player_two
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
    self.update!(board: "_________", state: :open)
  end

  def board_array
    board.split("")
  end
end
