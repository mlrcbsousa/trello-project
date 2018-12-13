Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  get 'sprints/pick', to: 'sprints#pick', as: 'pick'
  post 'sprints/new', to: 'sprints#new', as: 'new'

  resources :sprints, only: %i[create show index] do
    get 'members/contribute', to: 'members#contribute', as: 'contribute'
    patch 'members/labour', to: 'members#labour', as: 'labour'
    patch 'members/onboard', to: 'members#onboard', as: 'onboard'
  end
  get 'trello/:id', to: 'sprints#trello', as: 'trello'
  get 'knowledge', to: 'pages#knowledge', as: 'knowledge'
  get 'pricing', to: 'pages#pricing', as: 'pricing'
  get 'about', to: 'pages#about', as: 'about'

  resource :trello_webhooks, only: %i[show create], defaults: { formats: :json }
end
