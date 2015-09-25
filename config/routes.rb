Rails.application.routes.draw do
  resources :volunteers do
    get 'burndown_chart', to: 'burndown_chart#index'
  end

  get '/ping', to: 'website#ping'
  root to: 'website#index'
end
