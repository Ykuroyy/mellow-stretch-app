class HomeController < ApplicationController
  def index
    @today = Date.current
    @stretch = get_todays_stretch
    @breathing = get_todays_breathing
    @message = get_todays_message
    @recent_activities = get_recent_activities
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

  def get_recent_activities
    # 過去3日分の活動履歴を取得（実際の実装ではUserActivityテーブルを使用）
    []
  end
end
