class CreateStretches < ActiveRecord::Migration[7.1]
  def change
    create_table :stretches do |t|
      t.string :name
      t.text :description
      t.string :category
      t.integer :duration
      t.string :difficulty

      t.timestamps
    end
  end
end
