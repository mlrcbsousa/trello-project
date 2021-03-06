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

  # Updating
  post 'update/sprint/:id', to: 'update#sprint', as: 'update_sprint'
  post 'update/members/:id', to: 'update#members', as: 'update_members'
  post 'update/lists/:id', to: 'update#lists', as: 'update_lists'
  post 'update/cards/:id', to: 'update#cards', as: 'update_cards'

  # Server side editing contributors
  get 'members/contribute/:id', to: 'members#contribute', as: 'edit_contributors'
  patch 'members/contribute_patch/:id', to: 'members#contribute_patch', as: 'update_contributors'

  # Main
  resources :sprints, except: :new do
    resources :conversions, only: %i[edit update]
    resources :members, only: %i[index edit update]
  end

  # Webhooks
  get 'webhooks', to: 'webhooks#complete'
  post 'webhooks', to: 'webhooks#receive'

  # FRONT END TESTING ENVIRONMENT
  get 'sprints/refresh/:id', to: 'sprints#refresh'
  get 'testing/testing', to: 'testing#testing'
end
