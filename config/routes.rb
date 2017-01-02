Rails.application.routes.draw do
  root 'editions#index'

  resources :authors

  resources :books

  resources :editions

  resources :publishers
end
