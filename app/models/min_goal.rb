class MinGoal < ApplicationRecord
  belongs_to :goal

  with_options presence: true do
  validates :name
  validates :importance, inclusion: { in: 1..5 }, numericality: {only_integer: true}
  end

  attr_accessor :skip_deadline_validation

  validate :deadline_cannot_be_in_the_past,
           unless: :skip_deadline_validation

  private

  def deadline_cannot_be_in_the_past
    return if deadline.blank?
    return if deadline >= Date.current

    errors.add(:deadline, "は今日以降の日付を選択してください")
  end
end