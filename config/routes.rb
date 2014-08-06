Rails.application.routes.draw do
  devise_for :users
  resources :todos
  resources :histories do
    resources :comments
  end
  resources :projects
  
  root 'welcome#index'
end
