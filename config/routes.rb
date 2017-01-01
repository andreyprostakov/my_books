Rails.application.routes.draw do
  root 'editions#index'

  resources :authors

  resources :books

  resources :editions, except: :show
end
