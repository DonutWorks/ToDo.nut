Rails.application.routes.draw do
  # get 'users/merge(/:email)'

  get '/users/merge/:id/:provider(/:callback)', to: 'users#merge', as: 'users_merge'

  get 'users/show'

  get 'users/new'

  get 'user/new'

  devise_for :users, :controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations"
  }
  resources :users, only: [:show]

  resources :projects do

    resources :todos do
      collection do
        get 'list(/:id)', action: 'list'
      end
    end

    resources :histories do
      collection do
        get 'list(/:id)', action: 'list'
      end
      resources :comments
    end
    
    collection do
      get '(/:project_id)/main', action: 'main', as: 'main'
      

      
    end
    get 'members(/:nickname)', action: 'members', as: 'members'
  end

  
  root 'projects#index'
end
