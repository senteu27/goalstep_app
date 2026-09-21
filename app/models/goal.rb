class Goal < ApplicationRecord

  belongs_to :user
  has_many :min_goals

  accepts_nested_attributes_for :min_goals
end
