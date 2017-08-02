Rails.application.routes.draw do
  namespace :api do
    resources :links, only: :create
  end
end
