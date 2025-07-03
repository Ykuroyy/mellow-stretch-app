Rails.application.routes.draw do
  root "home#index"
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  # データリセットと実績記録
  post "home/reset_data" => "home#reset_data", as: :reset_data
  post "home/record_achievement" => "home#record_achievement", as: :record_achievement
  get "home/encouragement" => "home#encouragement", as: :encouragement
  
  # 詳細画面
  get "activities/history" => "activities#history", as: :activities_history
  get "activities/monthly" => "activities#monthly", as: :activities_monthly
  get "activities/daily/:date" => "activities#daily", as: :activities_daily
  
  # API endpoints for daily activities
  get "api/today" => "api#today"
  get "api/history" => "api#history"
  get "api/monthly_stats" => "api#monthly_stats"
end
