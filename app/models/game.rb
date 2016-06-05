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
    :x_win,
    :o_win
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
        return false unless current_player == new_board[index]
      end
      return false if changes > 1
    end
    true
  end

  def current_player
    xs = board_array.count("x")
    os = board_array.count("o")
    return "o" if xs > os
    return "x"
  end

  def check_for_win
    win = false
    wins = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]
    wins.each do |line|
      values = []
      line.each { |t| values << board_array[t]}
      win = true and break if values.uniq.count == 1 && values.uniq != ["_"]
    end

    if !win && board_array.count("_") == 0
      update(state: :tied)
    end

    if win
      xs = board_array.count("x")
      os = board_array.count("o")
      
      if current_player == "o"
        update(state: :x_win)
      else
        update(state: :o_win)
      end
    end
    win
  end

  private 

  def setup_board
    self.update!(board: "_________", state: :open)
  end

  def board_array
    board.split("")
  end
end
