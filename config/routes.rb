Rails.application.routes.draw do
  get '/ping', to: 'website#ping'
  get '/stylesheet', to: 'website#stylesheet'



  post "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure",            to: "sessions#failure"
  get "/logout",                  to: "sessions#destroy", :as => "logout"

  root to: "sessions#new"
end
