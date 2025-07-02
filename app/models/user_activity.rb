class UserActivity < ApplicationRecord
  validates :date, presence: true
  validates :activity_type, presence: true
  validates :activity_id, presence: true

  # 今日の活動を記録
  def self.record_today_activity(activity_type, activity_id)
    today = Date.current
    find_or_create_by(date: today, activity_type: activity_type, activity_id: activity_id)
  end

  # 過去3日分の活動履歴を取得
  def self.recent_activities(limit = 3)
    where('date >= ?', Date.current - limit.days)
      .order(date: :desc)
      .limit(limit)
  end

  # 過去1ヶ月分の活動履歴を取得
  def self.monthly_activities
    where('date >= ?', Date.current - 30.days)
      .order(date: :asc)
  end

  # 1ヶ月分の活動統計を取得（グラフ用）
  def self.monthly_stats
    activities = monthly_activities
    
    # 日付ごとの活動数を集計
    daily_counts = activities.group(:date, :activity_type).count
    
    # 30日分のデータを初期化
    stats = {}
    (Date.current - 30.days..Date.current).each do |date|
      stats[date] = {
        stretch: 0,
        breathing: 0,
        total: 0
      }
    end
    
    # 実際のデータを設定
    daily_counts.each do |(date, activity_type), count|
      if stats[date]
        stats[date][activity_type.to_sym] = count
        stats[date][:total] += count
      end
    end
    
    stats
  end

  # 活動の詳細情報を取得
  def activity_details
    case activity_type
    when 'stretch'
      Stretch.find_by(id: activity_id)
    when 'breathing'
      BreathingExercise.find_by(id: activity_id)
    else
      nil
    end
  end

  # 活動の表示名を取得
  def activity_name
    details = activity_details
    details&.name || "不明な活動"
  end

  # 活動の説明を取得
  def activity_description
    details = activity_details
    details&.description || ""
  end

  # 活動のアイコンを取得
  def activity_icon
    case activity_type
    when 'stretch'
      '🧘‍♀️'
    when 'breathing'
      '💨'
    else
      '📝'
    end
  end

  # 活動のカテゴリを取得
  def activity_category
    details = activity_details
    case activity_type
    when 'stretch'
      details&.category || "ストレッチ"
    when 'breathing'
      details&.benefit || "呼吸法"
    else
      "その他"
    end
  end
end
