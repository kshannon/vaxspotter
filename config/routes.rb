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

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    get 'admin' => 'admin#index'
    get 'providers' => 'providers#index'
    get  'static_pages/about'
    get  'static_pages/help'
    get  'static_pages/disclaimer'
    get  'static_pages/news'

    get '/:locale' => 'feed#index'
    root 'feed#index'
  end
end