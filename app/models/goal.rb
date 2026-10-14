class Goal < ApplicationRecord

  belongs_to :user
  has_many :min_goals, dependent: :destroy

  accepts_nested_attributes_for :min_goals

  with_options presence: true do
    validates :name
  end
end
