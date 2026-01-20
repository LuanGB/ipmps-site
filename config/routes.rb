require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  resources :sermons
  resources :posts
  resources :contacts, only: %i[ new create ]

  get "home", to: "site#home", as: "home"
  get "about", to: "site#about", as: "about"
  get "new", to: "contacts#new", as: "new"

  root to: "site#home"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Sidekiq Web UI (apenas para admins)
  authenticate :admin_user do
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
