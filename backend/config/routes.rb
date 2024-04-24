require Rails.root.join("lib/kb/crud_route_concern")

Rails.application.routes.draw do
  concern :kb_crud, KB::CrudRouteConcern.new

  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resources :dummies, concerns: :kb_crud

  resources :users, concerns: :kb_crud, :controller => "users"

  match '*unmatched', to: 'application#not_found', via: :all
end
