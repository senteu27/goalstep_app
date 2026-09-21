class CreateMinGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :min_goals do |t|

      t.timestamps
      t.string     :name,               null:false
      t.date       :deadline
      t.boolean    :check,              null:false, default: false
      t.integer    :importance,         null:false
      t.references :goal,               null:false, foreign_key:true
    end
  end
end
