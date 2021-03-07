# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  resources :sessions, only: [:create, :new] do
    collection do
      get :logout
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
  get ':page' => 'pages#show'
  root 'feed#index'

end
