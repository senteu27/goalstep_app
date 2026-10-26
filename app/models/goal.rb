class Goal < ApplicationRecord

  belongs_to :user
  has_many :min_goals, dependent: :destroy

  accepts_nested_attributes_for :min_goals

  with_options presence: true do
    validates :name
  end

  validate :min_goal_check

  private

  def min_goal_check
  if min_goals.empty?
    errors.add(:min_goals, "を1つ以上入力してください")
  end
end
end
