Rails.application.routes.draw do
  get 'users/sign_up_from_twitter/:id', to: 'users#sign_up_from_twitter', as: 'sign_up_from_twitter'
  post 'users/sign_up_from_twitter/:id', to: 'users#sign_up_from_twitter', as: 'sign_up_from_twitter_update'

  # get 'users/merge(/:email)'

  # resources :users do
  #   resources :
  # end

  get '/users/merge/:id/:provider(/:callback)', to: 'users#merge', as: 'users_merge'

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }

  #get '/users/(/:nickname)/edit', to: 'users/registrations#edit', as: 'edit_user'
  get '/users/(/:nickname)', to: 'users#show', as: 'show_user'
  #resources :users, only: [:show]

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
