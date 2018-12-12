Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  get 'sprints/pick', to: 'sprints#pick', as: 'pick'
  get 'sprints/new/:trello_ext_id/:name', to: 'sprints#new'

  resources :sprints, only: %i[create show index] do
    get 'members/contribute', to: 'members#contribute', as: 'contribute'
    patch 'members/labour', to: 'members#labour', as: 'labour'
    patch 'members/onboard', to: 'members#onboard', as: 'onboard'
  end

  resource :trello_webhooks, only: %i[show create], defaults: { formats: :json }
end
