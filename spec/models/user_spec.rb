require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end


  describe "ユーザー登録機能" do
    context "登録出来る時" do
      it "nicknameとemailとpasswordを記入すれば登録できる" do
      expect(@user).to be_valid
    end
    it "六文字以上の半角英数字のパスワードなら登録できる" do
      @user.password = "123456"
      @user.password_confirmation = "123456"

      expect(@user).to be_valid
    end
  end
    context "登録できない時" do
      it "nicknameがないと登録できない" do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to  include "Nickname can't be blank"
      end
      it "nicknameがスペースでは登録できない" do
        @user.nickname = " "
        @user.valid?
        expect(@user.errors.full_messages).to include "Nickname can't be blank"
      end
      it "emailがないと登録できない" do
        @user.email =''
        @user.valid?
        expect(@user.errors.full_messages).to include "Email can't be blank"
      end
      it "emailは@がないと登録できない" do
        @user.email = "user.email.com"
        @user.valid?
        expect(@user.errors.full_messages).to include "Email の形式が正しくありません"
      end
      it "emailは.の後に英語がなきゃ登録できない" do
        @user.email ="user@email"
        @user.valid?
        expect(@user.errors.full_messages).to include "Email の形式が正しくありません"
      end
      it "emailは1つにつき一アカウントしか登録できない" do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include "Email has already been taken"
      end
      it "passwordがないと登録できない" do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Password can't be blank"
      end
      it "passwordとpassword_confirmationは同じでないと登録できない" do
        @user.password = "111111"
        @user.password_confirmation = "a11111"
        @user.valid?
        expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
      end
      it "passwordは半角じゃないと登録できない" do
        @user.password = "１１１１１１"
        @user.password_confirmation = "１１１１１１"
        @user.valid?
        expect(@user.errors.full_messages).to include "Password は半角英数字のみにしてください"
      end
      it "passwordは六文字以上じゃないと登録できない" do
        @user.password ="12345"
        @user.password_confirmation = "12345"
        @user.valid?
        expect(@user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
      end
      it "passwordに記号を使うと登録できない" do
        @user.password = "123456!?"
        @user.password_confirmation = "123456!?"
        @user.valid?
        expect(@user.errors.full_messages).to include "Password は半角英数字のみにしてください"
      end
      it "passwordは128文字以下じゃないと登録できない" do
        @user.password = "a" * 129
        @user.password_confirmation = "a" * 129
        @user.valid?
        expect(@user.errors.full_messages).to include "Password is too long (maximum is 128 characters)"
      end
    end
  end
end
