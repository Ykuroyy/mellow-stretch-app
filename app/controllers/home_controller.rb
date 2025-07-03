class HomeController < ApplicationController
  def index
    @today = Date.current
    @stretch = get_todays_stretch
    @breathing = get_todays_breathing
    
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
    # パラメータからactivity_typeとactivity_idを取得
    activity_type = params[:activity_type] || params.dig(:home, :activity_type)
    activity_id = params[:activity_id] || params.dig(:home, :activity_id)
    date = Date.current
    @today = date  # @todayを設定
    
    # デバッグログ
    Rails.logger.info "record_achievement called with activity_type: #{activity_type}, activity_id: #{activity_id}"
    Rails.logger.info "All params: #{params.inspect}"
    Rails.logger.info "Request format: #{request.format}"
    Rails.logger.info "Request xhr?: #{request.xhr?}"
    
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
    
    # UserActivityも記録（履歴用）
    UserActivity.record_today_activity(activity_type, activity_id)
    
    # 応援メッセージを取得
    encouragement = EncouragementMessage.random_for_category(activity_type)
    
    # AJAXリクエストの場合はJSONを返す、フォーム送信の場合はリダイレクト
    if request.xhr?
      render json: { 
        success: true, 
        message: "#{activity_type == 'stretch' ? 'ストレッチ' : '呼吸法'}を完了しました！",
        completed: true,
        encouragement_message: encouragement&.message || "今日も一日頑張りましょう！"
      }
    else
      redirect_to root_path, notice: "#{activity_type == 'stretch' ? 'ストレッチ' : '呼吸法'}を完了しました！"
    end
  end

  def reset_achievement
    # パラメータからactivity_typeとactivity_idを取得
    activity_type = params[:activity_type] || params.dig(:home, :activity_type)
    activity_id = params[:activity_id] || params.dig(:home, :activity_id)
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
    
    # デバッグログ
    Rails.logger.info "get_another_stretch called with current_id: #{current_stretch_id}"
    Rails.logger.info "All params: #{params.inspect}"
    Rails.logger.info "Request format: #{request.format}"
    Rails.logger.info "Request xhr?: #{request.xhr?}"
    
    other_stretches = Stretch.where.not(id: current_stretch_id)
    new_stretch = other_stretches.sample
    
    # AJAXリクエストの場合はJSONを返す、通常のリンクの場合はリダイレクト
    if request.xhr?
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
    else
      # セッションに新しいストレッチIDを保存
      session[:current_stretch_id] = new_stretch.id
      redirect_to root_path, notice: "新しいストレッチを表示しました！"
    end
  end

  def get_another_breathing
    # 別の呼吸法を取得
    current_breathing_id = params[:current_id].to_i
    other_breathing = BreathingExercise.where.not(id: current_breathing_id)
    new_breathing = other_breathing.sample
    
    # AJAXリクエストの場合はJSONを返す、通常のリンクの場合はリダイレクト
    if request.xhr?
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
    else
      # セッションに新しい呼吸法IDを保存
      session[:current_breathing_id] = new_breathing.id
      redirect_to root_path, notice: "新しい呼吸法を表示しました！"
    end
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
    # セッションに新しいストレッチIDがある場合はそれを使用
    if session[:current_stretch_id]
      stretch = Stretch.find_by(id: session[:current_stretch_id])
      session.delete(:current_stretch_id) # 使用後は削除
      return stretch if stretch
    end
    
    # 日付に基づいてランダムにストレッチを選択（同じ日は同じ結果）
    srand(@today.to_time.to_i)
    Stretch.all.sample
  end

  def get_todays_breathing
    # セッションに新しい呼吸法IDがある場合はそれを使用
    if session[:current_breathing_id]
      breathing = BreathingExercise.find_by(id: session[:current_breathing_id])
      session.delete(:current_breathing_id) # 使用後は削除
      return breathing if breathing
    end
    
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
    # 過去3日分の活動履歴を取得（ダミーデータは作成しない）
    UserActivity.recent_activities(3)
  end

  def get_todays_achievements
    today = Date.current
    @today = today  # @todayを設定
    
    # 今日のストレッチと呼吸法のIDを取得
    srand(@today.to_time.to_i)
    stretch_id = Stretch.all.sample.id
    srand(@today.to_time.to_i + 1000)
    breathing_id = BreathingExercise.all.sample.id
    
    {
      stretch: Achievement.find_by(date: today, activity_type: 'stretch', activity_id: stretch_id)&.completed || false,
      breathing: Achievement.find_by(date: today, activity_type: 'breathing', activity_id: breathing_id)&.completed || false
    }
  end
end
