class User < ApplicationRecord
  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  enum :role, { user: "user", admin: "admin" }

  def self.strong_params
    [:email]
  end
end
