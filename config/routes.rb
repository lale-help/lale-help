Rails.application.routes.draw do
  resources :circles do
    scope module: 'circle' do
      resource  :calendar, :admin
      resources :members, :roles, :working_groups, :discussions

      resources :supplies do
        put :complete
        patch :complete
      end

      resources :tasks do
        collection do
          get :my
        end

        put :volunteer
        patch :volunteer
        put :decline
        patch :decline
        put :complete
        patch :complete
      end
    end
  end

  get '/ping', to: 'website#ping'

  get '/styles/:id', to: 'styleguides#show'

  namespace :user do
    resources :identities
  end

  namespace :api do
    resources :circles, only: [:index]
  end

  post "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure",            to: "sessions#failure"
  get "/logout",                  to: "sessions#destroy", :as => "logout"
  get "/register",                to: "user/identities#new", :as => "register"

  get "/token/:token_code", to: "tokens#handle_token", as: "handle_token"

  scope module: "user" do
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
