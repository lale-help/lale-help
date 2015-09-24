Rails.application.routes.draw do
  resources :circles
  resources :circles
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'
  root to: 'website#index'
end
