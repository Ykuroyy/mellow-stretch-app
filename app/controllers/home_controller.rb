class HomeController < ApplicationController
  def index
    @today = Date.current
    @stretch = get_todays_stretch
    @breathing = get_todays_breathing
    
    # 今日の活動を記録
    record_todays_activities
    
    # 過去の活動履歴を取得
    @recent_activities = get_recent_activities
    
    # 月別統計データを取得（グラフ用）
    @monthly_stats = Achievement.monthly_stats
    
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
    # JSONパラメータからactivity_typeとactivity_idを取得
    request_data = params[:activity_type] ? params : JSON.parse(request.body.read)
    activity_type = request_data['activity_type']
    activity_id = request_data['activity_id']
    date = Date.current
    @today = date  # @todayを設定
    
    # activity_idが指定されていない場合は、今日の活動から取得
    unless activity_id
      case activity_type
      when 'stretch'
        srand(@today.to_time.to_i)
        activity_id = Stretch.all.sample.id
      when 'breathing'
        srand(@today.to_time.to_i + 1000)
        activity_id = BreathingExercise.all.sample.id
      end
    end
    
    # 既存の実績を確認（activity_idも含めて）
    achievement = Achievement.find_or_initialize_by(date: date, activity_type: activity_type, activity_id: activity_id)
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

  def reset_achievement
    request_data = params[:activity_type] ? params : JSON.parse(request.body.read)
    activity_type = request_data['activity_type']
    activity_id = request_data['activity_id']
    date = Date.current
    @today = date  # @todayを設定
    
    # activity_idが指定されていない場合は、今日の活動から取得
    unless activity_id
      case activity_type
      when 'stretch'
        srand(@today.to_time.to_i)
        activity_id = Stretch.all.sample.id
      when 'breathing'
        srand(@today.to_time.to_i + 1000)
        activity_id = BreathingExercise.all.sample.id
      end
    end
    
    # 今日の実績を削除（activity_idも含めて）
    achievement = Achievement.find_by(date: date, activity_type: activity_type, activity_id: activity_id)
    achievement&.destroy
    
    # 成功メッセージを返す
    render json: { 
      success: true, 
      message: "#{activity_type == 'stretch' ? 'ストレッチ' : '呼吸法'}をやり直しにしました！",
      completed: false
    }
  end

  def get_another_stretch
    # 別のストレッチを取得
    current_stretch_id = params[:current_id].to_i
    other_stretches = Stretch.where.not(id: current_stretch_id)
    new_stretch = other_stretches.sample
    
    render json: {
      success: true,
      stretch: {
        id: new_stretch.id,
        name: new_stretch.name,
        description: new_stretch.description,
        duration: new_stretch.duration,
        category: new_stretch.category,
        difficulty: new_stretch.difficulty
      }
    }
  end

  def get_another_breathing
    # 別の呼吸法を取得
    current_breathing_id = params[:current_id].to_i
    other_breathing = BreathingExercise.where.not(id: current_breathing_id)
    new_breathing = other_breathing.sample
    
    render json: {
      success: true,
      breathing: {
        id: new_breathing.id,
        name: new_breathing.name,
        description: new_breathing.description,
        duration: new_breathing.duration,
        benefit: new_breathing.benefit,
        technique: new_breathing.technique
      }
    }
  end

  def encouragement
    @encouragement = EncouragementMessage.random_for_category(params[:category] || 'general')
  end

  def export_data
    # ユーザーデータを収集
    data = {
      achievements: Achievement.all.map { |a| { date: a.date, activity_type: a.activity_type, completed: a.completed } },
      user_activities: UserActivity.all.map { |ua| { date: ua.date, activity_name: ua.activity_name, activity_category: ua.activity_category } },
      export_date: Time.current.iso8601
    }
    
    # JSONファイルとしてダウンロード
    send_data data.to_json, 
              filename: "mellow_stretch_data_#{Date.current.strftime('%Y%m%d')}.json",
              type: 'application/json'
  end

  def import_data
    # データインポート機能（将来的に実装）
    redirect_to root_path, notice: 'データインポート機能は準備中です。'
  end

  def settings
    # 設定画面を表示
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
    @today = today  # @todayを設定
    stretch_id = get_todays_stretch.id
    breathing_id = get_todays_breathing.id
    
    {
      stretch: Achievement.find_by(date: today, activity_type: 'stretch', activity_id: stretch_id)&.completed || false,
      breathing: Achievement.find_by(date: today, activity_type: 'breathing', activity_id: breathing_id)&.completed || false
    }
  end
end
