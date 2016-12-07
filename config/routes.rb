Rails.application.routes.draw do
  root 'editions#index'

  resources :books

  resources :editions, expect: :show
end
