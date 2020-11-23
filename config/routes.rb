Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints format: :json do
    resources :persons
    get '/persons/:id/version/:version_id', to: 'persons#show_version'
    get '/persons/:id/history', to: 'persons#history'
  end
end
