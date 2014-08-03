Rails.application.routes.draw do
  devise_for :users
  resources :todos
  resources :histories

  root 'welcome#index'
end
