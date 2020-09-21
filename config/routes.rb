Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :books
      resources :users
      post 'login', to: 'users#login'
      post 'books/reserve/:id', to: 'books#reserve'
      post 'books/return/:id', to: 'books#return'
      get 'book/user_read', to: 'books#user_read'
      get 'book/own_books', to: 'books#own_books'
      get 'book/available_books', to: 'books#available_books'
      post 'book/return_to_owner/:id', to: 'books#return_to_owner'
      get 'book/expired', to: 'books#expired'
    end
  end
end
