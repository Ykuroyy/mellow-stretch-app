class CreateEncouragementMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :encouragement_messages do |t|
      t.text :message
      t.string :category

      t.timestamps
    end
  end
end
