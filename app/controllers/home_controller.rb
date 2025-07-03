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
    
    # 今日の実績を取得
    @today_achievements = get_todays_achievements
  end

  def reset_data
    # 過去のデータをリセット
    UserActivity.delete_all
    Achievement.delete_all
    
    redirect_to root_path, notice: '過去のデータをリセットしました。新しいスタートです！'
  end

  def record_achievement
    # JSONパラメータからactivity_typeを取得
    activity_type = params[:activity_type] || JSON.parse(request.body.read)['activity_type']
    date = Date.current
    
    # 既存の実績を確認
    achievement = Achievement.find_or_initialize_by(date: date, activity_type: activity_type)
    achievement.completed = true
    achievement.save!
    
    # 応援メッセージを取得
    encouragement = EncouragementMessage.random_for_category(activity_type)
    
    # 成功メッセージを返す
    render json: { 
      success: true, 
      message: "#{activity_type == 'stretch' ? 'ストレッチ' : '呼吸法'}を完了しました！",
      completed: true,
      encouragement_message: encouragement&.message || "今日も一日頑張りましょう！"
    }
  end

  def encouragement
    @encouragement = EncouragementMessage.random_for_category(params[:category] || 'general')
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

  def get_todays_achievements
    today = Date.current
    {
      stretch: Achievement.find_by(date: today, activity_type: 'stretch')&.completed || false,
      breathing: Achievement.find_by(date: today, activity_type: 'breathing')&.completed || false
    }
  end
end
