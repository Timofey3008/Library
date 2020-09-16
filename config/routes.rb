Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :books
      resources :users
      post 'login', to: 'users#login'
      post 'books/reserve/:id', to: 'books#reserve'
      post 'books/return/:id', to: 'books#return'
      get 'book/user_read', to: 'books#user_read'
    end
  end
end
