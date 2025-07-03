class AddActivityIdToAchievements < ActiveRecord::Migration[7.1]
  def up
    add_column :achievements, :activity_id, :integer
    
    # 既存のachievementsにactivity_idを設定
    # 同じ日付・同じactivity_typeのUserActivityからactivity_idを取得
    execute <<-SQL
      UPDATE achievements 
      SET activity_id = (
        SELECT ua.activity_id 
        FROM user_activities ua 
        WHERE ua.date = achievements.date 
        AND ua.activity_type = achievements.activity_type 
        LIMIT 1
      )
      WHERE activity_id IS NULL;
    SQL
  end

  def down
    remove_column :achievements, :activity_id
  end
end
