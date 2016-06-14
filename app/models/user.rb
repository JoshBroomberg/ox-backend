class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games

  after_create :set_image

  private

  def set_image
    self.update!(image: "http://www.nanigans.com/wp-content/uploads/2014/07/Generic-Avatar.png")
  end
end
