Rails.application.routes.draw do
  root 'editions#index'

  resources :authors, except: %i(show)

  resources :books, except: :show

  resources :editions do
    resource :status_read,
      controller: 'editions/status_read',
      only: %i(create destroy)
  end

  resources :publishers, except: %i(show)
end
