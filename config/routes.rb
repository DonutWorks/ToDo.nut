Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :projects do

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
    
    collection do
      get '(/:project_id)/main', action: 'main', as: 'main'
    end
    
  end
  
  root 'projects#index'
end
