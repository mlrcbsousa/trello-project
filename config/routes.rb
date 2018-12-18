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
  post 'conversions/:id', to: 'conversions#create', as: 'conversions'
  get 'onboard/contribute/:id', to: 'onboard#contribute', as: 'contribute'
  patch 'onboard/schedule/:id', to: 'onboard#schedule', as: 'schedule'
  patch 'onboard/complete/:id', to: 'onboard#complete', as: 'complete'


  # Main
  resources :sprints, except: :new do
    resources :conversions, only: %i[edit update]
    resources :members, only: %i[index edit update]
    get 'members/contribute', to: 'members#contribute'
    patch 'members/contribute_patch', to: 'members#contribute_patch', as: 'contribute_patch'
  end

  # Webhooks
  get 'webhooks', to: 'webhooks#complete'
  post 'webhooks', to: 'webhooks#receive'

  # FRONT END TESTING ENVIRONMENT
  # will use 'testing' layout unless otherwise specified in the pages#coontroller
  get 'testing', to: 'pages#testing'
end
