Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :circles do
    scope module: 'circle' do
      resource :admin do
        get :roles
        get :files
        get :working_groups
        get :invite
        get :extended_settings
        post :activate_member
      end

      resources :members do
        get :public, on: :collection
      end

      resources :roles, :organizers

      resources :supplies do
        put :complete, :volunteer, :decline, :reopen
        resources :comments, only: [:create, :index]

        post :invite
      end

      resources :working_groups do
        get :edit_members,    path: '/edit/members'
        get :edit_organizers, path: '/edit/organizers'
        get :edit_projects, path: '/edit/projects'
        patch :add_user
        delete :remove_user

        patch :join
        patch :leave

      end

      resources :tasks do
        collection do
          get :my
          get :open
          get :completed
        end
        resources :comments, only: [:create, :destroy, :update, :index]

        put :volunteer
        patch :volunteer
        put :decline
        patch :decline
        put :complete
        patch :complete
        put :reopen
        patch :reopen
        put :clone
        patch :clone

        post :invite
      end

      resources :projects do
        post :invite
      end

    end
  end

  resources :files, only: [:show, :create, :edit, :update, :destroy]
  resources :files, path: '/files/:uploadable', only: [:new]

  get '/ping', to: 'website#ping'

  get '/styles/:id', to: 'styleguides#show'

  namespace :user do
    resources :identities
  end

  namespace :api do
    resources :circles, only: [:index]
  end

  get "/register",  to: "user/identities#new", :as => "register"
  post "/register", to: "user/identities#create"

  get  "/join/:circle_id", to: 'circle/invite_flow#join',  as: 'join_circle'
  post "/join/:circle_id", to: 'circle/invite_flow#submit'

  get "/token/:token_code", to: "tokens#handle_token", as: "handle_token"

  scope module: "user" do
    get   '/account',                 to: 'account#show',              as: 'account'
    get   '/account/edit',            to: 'account#edit',              as: 'account_edit'
    patch '/account',                 to: 'account#update'
    get   '/account/reset_password',  to: 'account#reset_password',    as: 'account_reset_password'
    patch '/account/update_password', to: 'account#update_password',   as: 'account_update_password'
    get   '/account/switch_circle/:circle_id', to: 'account#switch_circle',  as: 'switch_circle'
  end


  scope module: "public" do
    get  "/reset_password", to: 'reset_password_flow#reset_password', as: 'public_reset_password'
    post "/reset_password", to: 'reset_password_flow#submit'
    get "/reset_password/confirmation", to: 'reset_password_flow#confirmation', as: 'public_reset_password_confirmation'
  end

  namespace :public do
    resources :circles, only: [:index, :new, :create] do
      post :join, on: :collection
      get :membership_pending, on: :member
    end
  end


  get  "/login",  to: "sessions#new",     as: "login"
  post "/login",  to: "sessions#create"
  get  "/logout", to: "sessions#destroy", as: "logout"

  root to: "sessions#new"
  ActiveAdmin.routes(self)
end
