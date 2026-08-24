## usersテーブル

|column            |type  |options    |
|nickname          |string|null: false|
|email             |string|null: false|
|encrypted_password|string|null: false|

## associations

has_many :goals

# goalsテーブル

|column  |type      |options                 |
|name    |string    |null: false             |
|deadline|date      |                        |
|user_id |references|null: false, foreign_key|

## associations

belongs_to :user
has_many :min_goals

## min_goalsテーブル

|column    |type      |options                 |
|name      |string    |null: false             |
|deadline  |date      |                        |
|check     |boolean   |null: false             |
|importance|integer   |null: false             |
|goal_id   |references|null: false, foreign_key|

## associations

belongs_to :goal

