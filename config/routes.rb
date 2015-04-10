Prelaunchr::Application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "dashboard#show"

  get 'refer-a-friend' => 'dashboard#refer', as: :user_refer
  get 'privacy-policy' => 'dashboard#policy', as: :user_policy

  unless Rails.application.config.consider_all_requests_local
      match '*not_found', to: 'dashboard#redirect', :format => false
  end
end
