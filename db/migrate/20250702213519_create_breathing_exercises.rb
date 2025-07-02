class CreateBreathingExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :breathing_exercises do |t|
      t.string :name
      t.text :description
      t.string :technique
      t.integer :duration
      t.string :benefit

      t.timestamps
    end
  end
end
