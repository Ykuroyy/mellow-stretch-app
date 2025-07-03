class Achievement < ApplicationRecord
  validates :date, presence: true
  validates :activity_type, presence: true, inclusion: { in: %w[stretch breathing] }
  validates :completed, inclusion: { in: [true, false] }
  
  scope :for_date, ->(date) { where(date: date) }
  scope :stretches, -> { where(activity_type: 'stretch') }
  scope :breathing_exercises, -> { where(activity_type: 'breathing') }
  scope :completed, -> { where(completed: true) }
  
  def self.mark_completed(date, activity_type)
    find_or_create_by(date: date, activity_type: activity_type) do |achievement|
      achievement.completed = true
    end
  end

  # 1ヶ月分の完了統計を取得
  def self.monthly_stats
    achievements = where(completed: true).where('date >= ?', Date.current - 30.days)
    
    # 日付ごとの完了数を集計
    daily_counts = achievements.group(:date, :activity_type).count
    
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
end
