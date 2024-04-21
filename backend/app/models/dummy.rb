class Dummy < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true

  def self.strong_params
    [:name, :description]
  end
end
