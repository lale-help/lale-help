Rails.application.routes.draw do
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'


  namespace :volunteer do
    resources :identities
  end

  post "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure",            to: "sessions#failure"
  get "/logout",                  to: "sessions#destroy", :as => "logout"
  get "/register",                to: "volunteer/identities#new", :as => "register"

  root to: "sessions#new"
end
