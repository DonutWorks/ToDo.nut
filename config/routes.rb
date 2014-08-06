Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :todos
  resources :histories do
    resources :comments
  end
  resources :projects
  
  root 'welcome#index'
end
