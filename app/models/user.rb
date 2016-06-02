class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  has_many :user_games
  has_many :games, through: :user_games
end
