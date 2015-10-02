Rails.application.routes.draw do
  resources :volunteers do
    get 'burndown_chart', to: 'burndown_chart#index'
  end

  resources :circles do
    resources :working_groups
    resources :tasks, only: [:index, :edit, :update, :new, :create, :destroy] do
      put :volunteer
      patch :volunteer
    end
  end

  get '/ping', to: 'website#ping'

  get '/styles/:id', to: 'styleguides#show'

  namespace :volunteer do
    resources :identities
  end

  post "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure",            to: "sessions#failure"
  get "/logout",                  to: "sessions#destroy", :as => "logout"
  get "/register",                to: "volunteer/identities#new", :as => "register"

  root to: "sessions#new"
end
