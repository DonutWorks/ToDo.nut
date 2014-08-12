Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations"
  }

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

  resources :projects
  
  root 'welcome#index'
end
