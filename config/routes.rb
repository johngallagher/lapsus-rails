Rails.application.routes.draw do
  devise_for :users
  root 'entries#index'

  namespace :api do
    namespace :v1 do
      resources :entries
    end
  end

  resources :containers, only: [:new, :create, :index, :destroy, :delete]
  resources :entries,    only: [:index]
  resources :projects,   only: [:index]
end
