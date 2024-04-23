require Rails.root.join("lib/kb/crud_route_concern")

Rails.application.routes.draw do
  concern :kb_crud, KB::CrudRouteConcern.new

  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resources :dummies

  get "/users" => "users#index"
  get "/users/:id" => "users#show"
end
