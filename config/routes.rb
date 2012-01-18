Changems::Application.routes.draw do
  resources :ruby_gems, only: [:index, :show]

  root to: 'ruby_gems#index'
end
