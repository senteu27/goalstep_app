require 'rails_helper'

RSpec.describe Goal, type: :model do

  before do
    @goal = FactoryBot.build(:goal)
    @user = FactoryBot.build(:user)
    @min_goal = FactoryBot.build(:min_goal)
  end

  describe "目標投稿機能" do
  context "目標を作成出来る時" do
    it "目標とミニゴールを入力すれば作成できる" do
      @goal.min_goals << @min_goal
      expect(@goal).to be_valid
      expect(@min_goal).to be_valid
    end
    it "goalのdeadlineはなくても作成できる" do
       @goal.min_goals << @min_goal
      @goal.deadline = nil
      expect(@goal).to be_valid
    end
    it "min_goalのdeadlineはなくても作成できる" do
      @goal.min_goals << @min_goal
      @min_goal.deadline = nil
      expect(@min_goal).to be_valid
    end
    it "importanceは1だと作成できる" do
      @min_goal.importance = 1
      expect(@min_goal).to be_valid
    end
    it "min_goalのimportanceは5だと作成できる" do
      @min_goal.importance = 5
      expect(@min_goal).to be_valid
    end
    it "checkの初期値はfalseである" do
      expect(@min_goal.check).to be false
    end
  end
  context "目標を作成できない時" do
    it "goalのnameが空では作成できない" do
      @goal.min_goals << @min_goal
      @goal.name = ""
      @goal.valid?
      expect(@goal.errors.full_messages).to include "Name can't be blank"
    end
    it "min_goalのnameが空では作成できない" do
      @min_goal.name = ""
      @min_goal.valid?
      expect(@min_goal.errors.full_messages).to include "Name can't be blank"
    end
    it "min_goalのimportanceが空では作成できない" do
      @min_goal.importance = ""
      @min_goal.valid?
      expect(@min_goal.errors.full_messages).to include "Importance can't be blank"
    end
    it "min_goalのimportanceの値は1~5じゃないと作成出来ない" do
      @min_goal.importance = 6
      @min_goal.valid?
      expect(@min_goal.errors.full_messages).to include "Importance is not included in the list"
    end
    it "min_goalのimportanceは0では作成できない" do
      @min_goal.importance = 0
      @min_goal.valid?
      expect(@min_goal.errors.full_messages).to include "Importance is not included in the list"
    end
    it "min_goalのimportanceの値は整数じゃないと作成できない" do
    @min_goal.importance = 3.5
    @min_goal.valid?
    expect(@min_goal.errors.full_messages).to include "Importance must be an integer"
    end
    it "min_goalのdeadlineは過去だと作成できない" do
      @min_goal.deadline = Date.new(2026,10,15)
      @min_goal.valid?
      expect(@min_goal.errors.full_messages).to include "Deadline は今日以降の日付を選択してください"
    end
    it "goalだけでは作成できない" do
      @goal.valid?
      expect(@goal.errors.full_messages).to include "Min goals を1つ以上入力してください"
    end
    it "min_goalはgoalに紐づいてないと作成できない" do
      @min_goal.goal = nil
      @min_goal.valid?
      expect(@min_goal.errors.full_messages).to include "Goal must exist"
  end
    it "goalにはuserが紐づいていないと作成できない" do
      @goal.user = nil
      @goal.valid?
      expect(@goal.errors.full_messages).to include "User must exist"
    end
  end
end
end