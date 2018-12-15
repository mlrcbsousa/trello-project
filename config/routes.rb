Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # General
  root to: 'pages#home'
  get 'knowledge', to: 'pages#knowledge', as: 'knowledge'
  get 'pricing', to: 'pages#pricing', as: 'pricing'
  get 'about', to: 'pages#about', as: 'about'

  # Onboarding
  get 'onboard/pick', to: 'onboard#pick', as: 'pick'
  post 'sprints/new', to: 'sprints#new', as: 'new'
  get 'conversions/new/:id', to: 'conversions#new', as: 'new_conversion'
  post 'conversions/:id', to: 'conversions#create'
  get 'onboard/contribute/:id', to: 'onboard#contribute', as: 'contribute'
  patch 'onboard/schedule/:id', to: 'onboard#schedule', as: 'schedule'
  patch 'onboard/complete/:id', to: 'onboard#complete', as: 'complete'

  # Main
  resources :sprints, only: %i[create show index] do
    resources :members, only: %i[index show]
  end

  # Webhooks
  get "/webhooks", to: "webhooks#complete"
  post "/webhooks", to: "webhooks#receive"
end
