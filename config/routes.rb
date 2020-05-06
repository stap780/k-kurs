Rails.application.routes.draw do

  resources :kurs do
    collection do
      get :updatekur
    end
  end
  root to: 'home#index'
  get '/insints' , to: 'home#index'
  resources :insints do
    collection do
      get :install
      get :uninstall
      get :login
      get :adminindex
      get :setup_script
      get :delete_script
      get :checkint
    end
  end

  constraints SubdomainConstraint do
    get '/dashboard/index' , to: 'dashboard#index'
    get '/dashboard/users', to: 'dashboard#users'
    get '/dashboard/test_email', to: 'dashboard#test_email'
    delete '/dashboard/user_destroy', to: 'dashboard#user_destroy'
  end # constraints

  devise_for :users, controllers: {
    registrations:  'users/registrations',
    sessions:       'users/sessions',
    passwords:      'users/passwords',
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
