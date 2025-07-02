class CreateUserActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :user_activities do |t|
      t.date :date
      t.string :activity_type
      t.integer :activity_id

      t.timestamps
    end
  end
end
