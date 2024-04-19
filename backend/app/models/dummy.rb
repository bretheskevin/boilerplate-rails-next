class Dummy < ApplicationRecord
  acts_as_paranoid

  def self.strong_params
    [:name, :description]
  end
end
