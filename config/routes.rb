Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :circles do
    scope module: 'circle' do
      resource :admin do
        get :roles
        get :working_groups
        get :invite
        post :activate_member
      end

      resources :members do
        put :activate, on: :member
        put :block, on: :member
        put :unblock, on: :member
        resources :comments, only: [:create, :index, :destroy, :update]
      end

      resources :roles, :organizers

      resources :supplies do
        put :complete, :volunteer, :decline, :reopen
        resources :comments, only: [:create, :index, :destroy, :update]

        post :invite
      end

      resources :working_groups do
        get :edit_members,    path: '/edit/members'
        get :edit_organizers, path: '/edit/organizers'
        get :edit_projects, path: '/edit/projects'
        patch :add_user
        delete :remove_user

        patch :join, :leave, :activate, :disable
      end

      resources :taskables do
        collection do
          get :volunteer
          get :organizer
        end
      end


      resources :tasks do
        collection do
          get :my
          get :open
          get :completed
        end
        resources :comments, only: [:create, :destroy, :update, :index]

        # FIXME task roles need a controller of their own!
        put   :volunteer, :assign_volunteer, :unassign_volunteer, :decline, :complete, :reopen, :clone
        patch :volunteer, :assign_volunteer, :unassign_volunteer, :decline, :complete, :reopen, :clone

        post :invite
      end

      resources :projects do
        post :invite
      end

      resources :documents, only: :index
    end

    resources :files, only: [:create, :edit, :destroy]
    resources :files, path: '/files/:uploadable', only: [:new]
  end

  resources :files, only: [:show, :update]

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
      get "membership_inactive/:status", action: :membership_inactive, as: :inactive_circle_membership
    end
  end


  get  "/login",  to: "sessions#new",     as: "login"
  post "/login",  to: "sessions#create"
  get  "/logout", to: "sessions#destroy", as: "logout"

  root to: "sessions#new"
  ActiveAdmin.routes(self)
end
