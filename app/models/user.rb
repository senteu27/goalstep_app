class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


         has_many :goals

         with_options presence: true do
         validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,message: "の形式が正しくありません" }
         validates :password, format: { with: /\A[a-zA-Z0-9]{6,}\z/,message: "は半角英数字のみにしてください" }
         validates :nickname
end
         
end
