Rails.application.routes.draw do
  get 'users/show'

  get 'users/new'

  get 'user/new'

  devise_for :users, :controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations"
  }
  resources :users, only: [:show]

  resources :todos do
    collection do
      get 'list(/:id)', action: 'list'
    end
  end

  resources :histories do
    collection do
      get 'list_members' # should move to projects#members
      get 'list(/:id)', action: 'list'
    end
    resources :comments
  end

  resources :projects do
    # get 'members(/:nickname)', action: 'members'
  end
  
  root 'welcome#index'
end
