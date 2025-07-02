Rails.application.routes.draw do
  get 'api/today'
  get 'api/history'
  root "home#index"
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  # API endpoints for daily activities
  get "api/today" => "api#today"
  get "api/history" => "api#history"
end
