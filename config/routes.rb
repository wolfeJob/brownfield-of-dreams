Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tutorials, only: [:show, :index]
      resources :videos, only: [:show]
    end
  end

  root "welcome#index"
  get "tags/:tag", to: "welcome#index", as: :tag
  get "/register", to: "users#new"

  namespace :api do
    namespace :v1 do
      post "/bookmarks", to: "bookmarks#create"
    end
  end

  namespace :admin do
    get "/dashboard", to: "dashboard#show"
    delete "/tutorials/:id", to: "tutorials#destroy", as: :delete_tutorial
    resources :playlists, only: [:new, :create]
    resources :tutorials, only: [:create, :edit, :update, :new] do
      resources :videos, only: [:create]
    end
    resources :videos, only: [:edit, :update, :destroy]

    namespace :api do
      namespace :v1 do
        put "tutorial_sequencer/:tutorial_id", to: "tutorial_sequencer#update"
      end
    end
  end

  get "/auth/github", as: :github_login
  get "/auth/github/callback", to: "github#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/dashboard", to: "users#show"
  post "/friends/:uid", to: "friendship#create", as: :add_friend
  get "/invite", to: "invites#new"
  post "/invite", to: "invites#create"
  get "/about", to: "about#show"
  get "/get_started", to: "get_started#show"

  # Is this being used?
  get "/video", to: "video#show"

  resources :users, only: [:new, :create, :update, :edit] do
    member do
      get :confirm_email
    end
  end

  resources :tutorials, only: [:show, :index] do
    resources :videos, only: [:show, :index]
  end

  resources :user_videos, only: [:create, :destroy]
end
