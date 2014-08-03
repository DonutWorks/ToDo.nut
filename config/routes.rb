Rails.application.routes.draw do
  resources :todos
  resources :histories

  root 'welcome#index'
end
