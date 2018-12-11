Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  get 'pick_sprint' to: 'sprints#pick_sprint'
  resources :sprints, only: %i[new]

  resource :trello_webhooks, only: %i[show create], defaults: { formats: :json }

end
