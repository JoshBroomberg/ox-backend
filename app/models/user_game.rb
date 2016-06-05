class UserGame < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  after_create :setup_player_one

  validates_uniqueness_of :player_one, scope: :game_id

  def setup_player_one
    # Could randomise.
    self.update!(player_one: true) if player_one == nil
  end
end
