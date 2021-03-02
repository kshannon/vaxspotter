# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  resources :sessions, only: [:create, :new] do
    collection do
      get :logout
    end
  end

  post 'test_tweet' => 'twitter#test_tweet', as: :test_tweet
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'admin' => 'admin#index'
  get ':page' => 'pages#show'
  root 'feed#index'

end
