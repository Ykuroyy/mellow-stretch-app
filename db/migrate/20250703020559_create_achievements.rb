class CreateAchievements < ActiveRecord::Migration[7.1]
  def change
    create_table :achievements do |t|
      t.date :date
      t.string :activity_type
      t.boolean :completed

      t.timestamps
    end
  end
end
