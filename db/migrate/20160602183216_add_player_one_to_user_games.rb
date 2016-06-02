class AddPlayerOneToUserGames < ActiveRecord::Migration
  def change
    add_column :user_games, :player_one, :boolean
  end
end
