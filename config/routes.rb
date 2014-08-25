Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }

  controller :users do
    get 'users/sign_up_from_twitter', action: 'sign_up_from_twitter', as: 'sign_up_from_twitter'
    post 'users/sign_up_from_twitter_callback', action: 'sign_up_from_twitter_callback', as: 'sign_up_from_twitter_callback'

    get 'users/merge', action: 'merge', as: 'users_merge'
    get 'users/merge/callback', action: 'merge_callback', as: 'users_merge_callback'
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
