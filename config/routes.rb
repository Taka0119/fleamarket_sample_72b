Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  devise_scope :user do
    get 'shipments', to: 'users/registrations#new_shipment'
    post 'shipments', to: 'users/registrations#create_shipment'
  end
  root 'items#index'
  resources :products do
    collection do
      get :get_category_children, defaults: { format: 'json'}
      get :get_category_grandchildren, defaults: { format: 'json'}
      get :searchChild
      get :update_done
    end
    resources :comments, only: :create
  end
end
