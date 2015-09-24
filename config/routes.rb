Rails.application.routes.draw do
  resources :circles do
    resources :working_groups
  end
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'
  get '/signup', to: 'website#signup'
  root to: 'website#index'
end
