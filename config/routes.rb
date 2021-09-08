Rails.application.routes.draw do

  # get '/pins/index'
  # get  '/pins/new'
  # post '/pins/create'

  resources :pins do
    resources :comments
  end

  resources :users do
    resources :pinlist
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

