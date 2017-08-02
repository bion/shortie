Rails.application.routes.draw do
  namespace :api do
    resources :links, only: :create
    get '/links/:short_name', to: 'links#show', as: 'link'
  end

  get '/l/:short_name', to: 'links#show'
end
