FactoryBot.define do
  factory :min_goal do
    name {"小テスト"}
    importance {3}
    check {false}
    deadline {Date.current}
    association :goal
  end
end