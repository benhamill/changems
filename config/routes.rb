Changems::Application.routes.draw do
  resources :ruby_gems, only: [:index, :show]
  resources :versions, only: [:show]
  match '/versions/:start_id/:end_id' => 'versions#range', as: 'version_range', via: :get

  root to: 'ruby_gems#index'
end
