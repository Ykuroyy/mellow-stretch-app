class HomeController < ApplicationController
  def index
    @today = Date.current
    @stretch = get_todays_stretch
    @breathing = get_todays_breathing
    @message = get_todays_message
    
    # 今日の活動を記録
    record_todays_activities
    
    # 過去の活動履歴を取得
    @recent_activities = get_recent_activities
    
    # 月別統計データを取得（グラフ用）
    @monthly_stats = UserActivity.monthly_stats
  end

  private

  def get_todays_stretch
    # 日付に基づいてランダムにストレッチを選択（同じ日は同じ結果）
    srand(@today.to_time.to_i)
    Stretch.all.sample
  end

  def get_todays_breathing
    # 日付に基づいてランダムに呼吸法を選択（同じ日は同じ結果）
    srand(@today.to_time.to_i + 1000) # ストレッチと異なる結果にするため
    BreathingExercise.all.sample
  end

  def get_todays_message
    # 日付に基づいてランダムにメッセージを選択（同じ日は同じ結果）
    srand(@today.to_time.to_i + 2000) # 他のコンテンツと異なる結果にするため
    DailyMessage.all.sample
  end

  def record_todays_activities
    # 今日のストレッチと呼吸法を記録
    UserActivity.record_today_activity('stretch', @stretch.id)
    UserActivity.record_today_activity('breathing', @breathing.id)
  end

  def get_recent_activities
    # 過去3日分の活動履歴を取得
    UserActivity.recent_activities(3)
  end
end
