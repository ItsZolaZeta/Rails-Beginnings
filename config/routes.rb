Rails.application.routes.draw do

  root to: 'pins#index'

  resources :pins do
    resources :comments
  end

  resources :users do
    resources :pinlist
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

