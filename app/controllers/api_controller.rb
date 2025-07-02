class ApiController < ApplicationController
  def today
    today = Date.current
    stretch = get_todays_stretch(today)
    breathing = get_todays_breathing(today)
    message = get_todays_message(today)
    
    render json: {
      date: today,
      stretch: {
        name: stretch.name,
        description: stretch.description,
        category: stretch.category,
        duration: stretch.duration,
        difficulty: stretch.difficulty
      },
      breathing: {
        name: breathing.name,
        description: breathing.description,
        technique: breathing.technique,
        duration: breathing.duration,
        benefit: breathing.benefit
      },
      message: {
        text: message.message,
        category: message.category
      }
    }
  end

  def history
    # 過去3日分の履歴を返す
    activities = UserActivity.recent_activities(3)
    
    history_data = activities.map do |activity|
      {
        date: activity.date,
        activity_type: activity.activity_type,
        name: activity.activity_name,
        description: activity.activity_description,
        category: activity.activity_category,
        icon: activity.activity_icon
      }
    end
    
    render json: {
      history: history_data
    }
  end

  def monthly_stats
    # 1ヶ月分の統計データを返す
    stats = UserActivity.monthly_stats
    
    chart_data = {
      labels: [],
      stretch_data: [],
      breathing_data: [],
      total_data: []
    }
    
    stats.each do |date, data|
      chart_data[:labels] << date.strftime("%m/%d")
      chart_data[:stretch_data] << data[:stretch]
      chart_data[:breathing_data] << data[:breathing]
      chart_data[:total_data] << data[:total]
    end
    
    render json: {
      chart_data: chart_data,
      summary: {
        total_days: stats.count { |_, data| data[:total] > 0 },
        total_activities: stats.values.sum { |data| data[:total] },
        stretch_count: stats.values.sum { |data| data[:stretch] },
        breathing_count: stats.values.sum { |data| data[:breathing] }
      }
    }
  end

  private

  def get_todays_stretch(date)
    srand(date.to_time.to_i)
    Stretch.all.sample
  end

  def get_todays_breathing(date)
    srand(date.to_time.to_i + 1000)
    BreathingExercise.all.sample
  end

  def get_todays_message(date)
    srand(date.to_time.to_i + 2000)
    DailyMessage.all.sample
  end
end
