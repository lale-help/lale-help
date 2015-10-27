Rails.application.routes.draw do
  resources :circles do
    resources :working_groups
    resources :tasks, only: [:index, :edit, :update, :new, :create, :destroy] do
      put :volunteer
      patch :volunteer
      put :complete
      patch :complete
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

  get "/token/:token_code", to: "tokens#handle_token", as: "handle_token"

  scope module: "volunteer" do
    get   '/account',                 to: 'account#edit',              as: 'account'
    get   '/account/reset_password',  to: 'account#reset_password',    as: 'account_reset_password'
    patch '/account/update_password', to: 'account#update_password',   as: 'account_update_password'
  end


  scope module: "public" do
    get  "/reset_password", to: 'reset_password_flow#reset_password', as: 'public_reset_password'
    post "/reset_password", to: 'reset_password_flow#submit'
    get "/reset_password/confirmation", to: 'reset_password_flow#confirmation', as: 'public_reset_password_confirmation'
  end

  root to: "sessions#new"
end
