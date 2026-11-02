require 'rails_helper'

RSpec.describe '目標作成', type: :system do
  before do
    @user = FactoryBot.build(:user)
    @goal = FactoryBot.build(:goal)
    @min_goal = FactoryBot.build(:min_goal)
  end

  context "目標作成出来る時" do
    it "ログインし必要な情報を記入し作成ボタンを押すと目標を作れる" do
      @user.save!
      visit new_user_session_path
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      click_button "ログイン"
      click_link "目標作成フォーム"
      expect(page).to have_current_path(new_goal_path)
      fill_in "目標", with: @goal.name
      fill_in "期限（任意）", with: @goal.deadline
      fill_in "例：毎月1万円貯金する", with: @min_goal.name
      fill_in "期限(任意）", with: @min_goal.deadline
      find('label[for="goal_min_goals_attributes_0_importance_5"]').click
      expect {
        click_button "作成する"
      sleep 3
    }.to change(Goal, :count).by(1)
      .and change(MinGoal, :count).by(1)
      expect(page).to have_current_path(goal_path(Goal.last))
    end
  end

  context "目標作成できない時" do
    it "ログインしてないと目標作成できない" do
      visit new_goal_path
      expect(page).to have_current_path(new_user_session_path)
      @user.save!
      visit new_user_session_path
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      click_button "ログイン"
      sleep 1
      visit root_path
      click_link "目標作成フォーム"
      expect(page).to have_current_path(new_goal_path)
      fill_in "目標", with: @goal.name
      fill_in "期限（任意）", with: @goal.deadline
      fill_in "例：毎月1万円貯金する", with: @min_goal.name
      fill_in "期限(任意）", with: @min_goal.deadline
      find('label[for="goal_min_goals_attributes_0_importance_5"]').click
        click_button "作成する"
        sleep 2
        click_link "ログアウト"
        sleep 1
      visit goal_path(Goal.last)
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end