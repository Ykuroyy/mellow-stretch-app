class ClearDummyUserActivities < ActiveRecord::Migration[7.0]
  def up
    # UserActivityテーブルのすべてのレコードを削除します
    UserActivity.delete_all
    puts "Cleared all records from UserActivity table."
  end

  def down
    # このマイグレーションはデータを削除するだけなので、downは何もしません。
    # ロールバックしてもデータは復元されません。
  end
end