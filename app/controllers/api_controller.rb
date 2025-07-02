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
    # 過去3日分の履歴を返す（実際の実装ではUserActivityテーブルを使用）
    render json: {
      history: []
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
