require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context "ユーザー登録出来る時" do
      it "正しい情報を入力したら登録してトップページに遷移する" do
        visit root_path
         expect(page).to have_content('新規登録')
         visit new_user_registration_path
         fill_in 'ニックネーム', with: @user.nickname
         fill_in 'メールアドレス', with: @user.email
         fill_in 'パスワード', with: @user.password
         fill_in 'パスワード（確認）', with: @user.password_confirmation
         expect {find('input[name="commit"]').click
         sleep 3
        }.to change {User.count}.by(1)
        expect(page).to have_current_path(root_path)
        expect(page).to have_content('ログアウト')
        expect(page).to have_no_content('新規登録')
        expect(page).to have_no_content('ログイン')
    end
    it "正しい情報を入力したらログインでき対応するuserにログインできる" do
      @user.save!
      visit root_path
      expect(page).to have_content('ログイン')
      click_link 'ログイン'
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      click_button 'ログイン'
      expect(page).to have_current_path(root_path)
    end
  end
  context "ユーザー登録できない" do
    it "間違った情報を入力したら新規登録できない" do
      visit root_path
      expect(page).to have_content('新規登録')
      click_link '新規登録'
      fill_in 'ニックネーム', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with:''
      fill_in 'パスワード（確認）', with: ''
      click_button '新規登録する'
      expect(page).to have_current_path(new_user_registration_path)
    end
    it "間違った情報を入力したらログインできない" do
      visit root_path
      expect(page).to have_content('ログイン')
      click_link 'ログイン'
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
