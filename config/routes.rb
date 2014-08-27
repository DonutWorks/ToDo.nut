Rails.application.routes.draw do
  # get 'users/merge(/:email)'

  get '/users/merge/:id/:provider(/:callback)', to: 'users#merge', as: 'users_merge'
  
  devise_for :users, :controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
  
  devise_scope :user do
    get '/users/(/:nickname)/edit', to: 'users/registrations#edit', as: 'edit_user', :constraints => { :nickname => /[^\/]+/ }
  end

  get '/users/(/:nickname)', to: 'users#show', as: 'show_user', :constraints => { :nickname => /[^\/]+/ }
  #resources :users, only: [:show]

  get 'projects/new', to: 'projects#new', as: 'new_project'
  
  
  resources :projects, :path =>'/:creator', param: :title do
    resources :todos, param: :ptodo_id do
      collection do
        get 'list(/:id)', action: 'list', defaults: {format: 'json'}
      end
    end

    resources :histories, param: :phistory_id do
      collection do
        get 'list(/:phistory_id)', action: 'list', defaults: {format: 'json'}
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
