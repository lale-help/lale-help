Rails.application.routes.draw do
  get 'burndown_chart', to: 'burndown_chart#index'

  get '/ping', to: 'website#ping'
  root to: 'website#index'
end
