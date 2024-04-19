class Dummy < ApplicationRecord
  def self.strong_params
    [:name, :description]
  end
end
