Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root 'reports#index'

  namespace :api do
    namespace :v1 do
      resources :entries
    end
  end

  resources :containers, only: [:create, :destroy]
  resources :entries,    only: [:index]
  resources :reports,    only: [:index]
  resources :projects,   only: [:index]
end
