Rails.application.routes.draw do

  #登録系で使うデバイスのルーティングを先に書く
  devise_for :admin, skip: [:registrations, :passwords], controllers: {  #新規登録とパス変更は使わない
    sessions: "admin/sessions"  #管理者が使うのはログインだけ
  }
  devise_for :customers,skip: [:passwords], controllers: {  #パス変更は使わない
    registrations: "public/registrations",
    sessions: 'public/sessions'  #ユーザーが使うのは新規登録とログイン
  }

  devise_scope :customer do
    post 'customer/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  #publicのルーティング
  scope module: :public do
    root to: 'homes#top'
    get '/about', to:'homes#about', as:'about'
    get '/customers', to:'customers#index', as:'customers_index'
    get 'customers/my_page', to: 'customers#show', as: 'my_page'
    resources :customers, only: [:show] do
      collection do
        get 'my_page/edit', to: 'customers#edit', as: 'edit_my_page'
        patch 'information', to: 'customers#update', as: 'update_information'
        delete 'out'
      end
      member do
        get 'favorite'
      end
      resource :relationships, only: [:create, :destroy]
        get "follower_customer" => "relationships#follower_customer", as: "follower"
        get "followed_customer" => "relationships#followed_customer", as: "followed"
      end
    resources :ideas, only: %i[index new create edit update destroy] do
      resource :favorites, only: %i[create destroy]
    end
    resources :rooms, only: %i[show create]
    resources :messages, only: %i[create]
    get "/search", to: "searches#search"
  end

  #adminのルーティング
  get 'admin', to: 'admin/homes#top'
  namespace :admin do
    resources :customers, only: [:edit, :update]
  end

end
