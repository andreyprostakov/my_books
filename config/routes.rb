Rails.application.routes.draw do
  root 'editions#index'

  resources :authors

  resources :books, except: :show

  resources :editions

  resources :publishers

  get 'categories/:code' => 'edition_categories#show', as: :category
end
