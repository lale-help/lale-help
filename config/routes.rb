Rails.application.routes.draw do
  get '/ping', to: 'website#ping'
  root to: 'website#index'
end
