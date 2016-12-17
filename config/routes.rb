Rails.application.routes.draw do
  root 'editions#index'

  resources :books

  resources :editions, except: :show
end
