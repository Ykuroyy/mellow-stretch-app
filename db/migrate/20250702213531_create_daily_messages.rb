class CreateDailyMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_messages do |t|
      t.text :message
      t.string :category

      t.timestamps
    end
  end
end
