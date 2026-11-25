class CreateChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_messages do |t|

      t.timestamps
      t.string       :role,     null:     false
      t.text         :content,  null:     false
      t.references   :user,     null:     false, foreign_key: true
    end
  end
end
