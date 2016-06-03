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
    :abandoned,
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

  def user_is_player?(user)
    users.include? user
  end

  def valid_move?(new_board)
    return false unless new_board.length == 9
    changes = 0
    xs = board_array.count("x")
    os = board_array.count("o")

    board_array.each_with_index do |value, index|
      if value != new_board[index]
        changes += 1
        return false if value == "x" || value == "o"
        return false unless new_board[index] == "x" || new_board[index] == "o"
        if xs > os
          return false if new_board[index] == "x"
        elsif xs == os
          return false if new_board[index] == "o"
        end
      end
      return false if changes > 1
    end
    true
  end

  private 

  def setup_board
    self.update!(board: "_________", state: :open)
  end

  def board_array
    board.split("")
  end
end
