class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  # Setting basic roles, there is room to modify this later (use ability.rb)
  ROLES = %w[admin user].freeze
end
