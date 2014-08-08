Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  match 'todos/list(/:id)' => 'todos#list', :via => :get
  resources :todos

  match 'histories/list_members' => 'histories#list_members', :via => :get
  match 'histories/list(/:id)' => 'histories#list', :via => :get
  resources :histories do
    resources :comments
  end

  resources :projects
  
  root 'welcome#index'
end
