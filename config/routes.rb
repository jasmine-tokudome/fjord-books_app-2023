Rails.application.routes.draw do
  devise_for :users
  root 'books#index'
  resources :users, :only => [:index,:show]
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_scope :user do
    get 'auth/logout' => 'devise/sessions#destroy'
    get 'users/show'
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
