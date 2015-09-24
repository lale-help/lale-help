Rails.application.routes.draw do
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'
  get '/signup', to: 'website#signup'
  root to: 'website#index'
end
