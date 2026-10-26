FactoryBot.define do
  factory :goal do
    name {"テスト"}
    deadline { Date.new(3000, 1, 1) }
    association :user
  end
end
