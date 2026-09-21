class MinGoal < ApplicationRecord

  validate :deadline_cannot_be_in_the_past

private

def deadline_cannot_be_in_the_past
  return if deadline.blank?
  return if deadline >= Date.current

  errors.add(:deadline, "は今日以降の日付を選択してください")
  belongs_to :goal

  validate :name, presence: true
  validates :importance, inclusion: { in: 1..5 }
end
end
