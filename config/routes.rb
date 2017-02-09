Rails.application.routes.draw do
  root 'editions#index'

  resources :authors

  resources :books, except: :show

  resources :editions do
    resource :status_read,
      controller: 'editions/status_read',
      only: %i(create destroy)
  end

  resources :publishers

  get 'categories/:code' => 'edition_categories#show', as: :category
end
