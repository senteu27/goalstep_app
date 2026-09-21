class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|

      t.timestamps
      t.string     :name,          null:false
      t.date       :deadline
      t.references :user,       null:false, foreign_key:true
    end
  end
end
