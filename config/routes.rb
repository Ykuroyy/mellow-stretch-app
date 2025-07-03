Rails.application.routes.draw do
  root "home#index"
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  # データリセットと実績記録
  post "home/reset_data" => "home#reset_data", as: :reset_data
  post "home/record_achievement" => "home#record_achievement", as: :record_achievement
  post "home/reset_achievement" => "home#reset_achievement", as: :reset_achievement
  get "home/encouragement" => "home#encouragement", as: :encouragement
  get "home/settings" => "home#settings", as: :settings
  get "home/export_data" => "home#export_data", as: :export_data
  
  # 別のストレッチ・呼吸法を取得
  get "home/get_another_stretch" => "home#get_another_stretch", as: :get_another_stretch
  get "home/get_another_breathing" => "home#get_another_breathing", as: :get_another_breathing
  
  # 詳細画面
  get "activities/history" => "activities#history", as: :activities_history
  get "activities/monthly" => "activities#monthly", as: :activities_monthly
  get "activities/daily/:date" => "activities#daily", as: :activities_daily
  
  # API endpoints for daily activities
  get "api/today" => "api#today"
  get "api/history" => "api#history"
  get "api/monthly_stats" => "api#monthly_stats"
end
