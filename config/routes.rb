Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }

  resources :users, only: :index do
    collection do
      get 'sign_up_from_twitter'
      post 'sign_up_from_twitter_callback'

      get 'merge'
      post 'merge_callback'

      get 'nickname_new'
      post 'nickname_new_callback'
    end
  end

  get '/users/(/:nickname)', to: 'users#show', as: 'show_user'

  resources :projects do
    resources :todos do
      collection do
        get 'list(/:id)', action: 'list', defaults: {format: 'json'}
      end
    end

    resources :histories do
      collection do
        get 'list(/:id)', action: 'list', defaults: {format: 'json'}
      end
      resources :comments
    end

    member do
      get 'detail'
      get 'members(/:nickname)', action: 'members', as: 'members', defaults: {format: 'json'}

    end

  end


  root 'projects#index'
end
