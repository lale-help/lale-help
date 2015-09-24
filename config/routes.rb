Rails.application.routes.draw do
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'
  root to: 'website#index'

  resources :circles do
    resources :tasks
  end

end
