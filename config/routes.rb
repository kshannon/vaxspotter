# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  resources :sessions, only: [:create, :new] do
    collection do
      post :logout
    end
  end

  scope '/admin' do
    resources :locations
    post "new_location", to: 'locations#create'

    resources :appointments do
      collection {post :import }
    end
    post "new_appointment", to: 'appointments#create'
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'admin' => 'admin#index'
  get 'providers' => 'providers#index'
  # get ':page' => 'pages#show'
  get  'static_pages/about'
  get  'static_pages/help'
  get  'static_pages/disclaimer'
  get  'static_pages/news'

  root 'feed#index'

end
