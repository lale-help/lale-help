Rails.application.routes.draw do
  resources :circles do
    resources :working_groups
  end
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'
  get '/styles/signup', to: 'website#signup'

  namespace :volunteer do
    resources :identities
  end

  resources :circles do
    resources :tasks, only: [:index, :edit, :new, :destroy]
  end
  
  post "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure",            to: "sessions#failure"
  get "/logout",                  to: "sessions#destroy", :as => "logout"
  get "/register",                to: "volunteer/identities#new", :as => "register"

  root to: "sessions#new"
end
