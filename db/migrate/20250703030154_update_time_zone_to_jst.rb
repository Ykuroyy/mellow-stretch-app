class UpdateTimeZoneToJst < ActiveRecord::Migration[7.1]
  def up
    # データベースのタイムゾーンをJSTに設定
    execute "SET timezone = 'Asia/Tokyo';"
    
    # 既存のタイムスタンプデータをJSTに変換
    # 注意: 既存のデータはUTCとして保存されているため、9時間を加算
    execute "UPDATE achievements SET updated_at = updated_at + INTERVAL '9 hours' WHERE updated_at IS NOT NULL;"
    execute "UPDATE achievements SET created_at = created_at + INTERVAL '9 hours' WHERE created_at IS NOT NULL;"
    execute "UPDATE user_activities SET updated_at = updated_at + INTERVAL '9 hours' WHERE updated_at IS NOT NULL;"
    execute "UPDATE user_activities SET created_at = created_at + INTERVAL '9 hours' WHERE created_at IS NOT NULL;"
  end

  def down
    # タイムスタンプデータをUTCに戻す
    execute "UPDATE achievements SET updated_at = updated_at - INTERVAL '9 hours' WHERE updated_at IS NOT NULL;"
    execute "UPDATE achievements SET created_at = created_at - INTERVAL '9 hours' WHERE created_at IS NOT NULL;"
    execute "UPDATE user_activities SET updated_at = updated_at - INTERVAL '9 hours' WHERE updated_at IS NOT NULL;"
    execute "UPDATE user_activities SET created_at = created_at - INTERVAL '9 hours' WHERE created_at IS NOT NULL;"
  end
end
