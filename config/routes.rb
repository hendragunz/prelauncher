Prelaunchr::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, skip: [:sessions]

  root :to => "dashboard#show"

  get 'refer-a-friend' => 'dashboard#refer',    as: :user_refer
  get 'privacy-policy' => 'dashboard#policy',   as: :user_policy
  get 'top-list'       => 'dashboard#top_list', as: :user_top

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'dashboard#redirect', :format => false
  end
end
