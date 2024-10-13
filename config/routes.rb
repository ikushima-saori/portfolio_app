Rails.application.routes.draw do

  #登録系で使うデバイスのルーティングを先に書く
  devise_for :admin, skip: [:registrations, :passwords], controllers: {  #新規登録とパス変更は使わない
    sessions: "admin/sessions"  #管理者が使うのはログインだけ
  }
  devise_for :customers,skip: [:passwords], controllers: {  #パス変更は使わない
    registrations: "public/registrations",
    sessions: 'public/sessions'  #ユーザーが使うのは新規登録とログイン
  }

  #ゲストログインのルーティング
  devise_scope :customer do
    post 'customer/guest_sign_in', to:'public/sessions#guest_sign_in'
  end

  #publicのルーティング
  scope module: :public do
    root to: 'homes#top'
    get '/about', to:'homes#about', as:'about'
    get '/customers', to:'customers#index', as:'customers_index'  #「/customers」 = homes#index:customers_index_path
    get 'customers/my_page', to:'customers#show', as:'my_page'  #「/customers/my_page」 = customers#show:my_page_path 自分のshow
    resources :customers, only: [:show] do  #「/customers/:id」 = customers#show:customer_path 他人のshow
      collection do
        get 'my_page/edit', to:'customers#edit', as:'edit_my_page'  #「/customers/my_page/edit」 = customers#edit:edit_my_page_path
        patch 'information', to:'customers#update', as:'update_information'  #「/customers/information」 = customers#update:update_information_path patchアクション
        delete 'out'  #「/customers/out」 = customers#out outアクション
      end
      member do
        get 'favorite'  #「/customers/:id/favorite」 = customers#favorite
        resource :relationships, only: [:create, :destroy]  #「/customers/:id/relationships」 = relationships#create&destroy:relationships_path
          get "follower_customer" => "relationships#follower_customer", as:"follower"  #「/customers/:id/follower_customer」 = relationships#follower_customer:follower_customer_path
          get "followed_customer" => "relationships#followed_customer", as:"followed"  #「/customers/:id/followed_customer」 = relationships#followed_customer:followed_customer_path
      end  #↑resources :customers, only: [:show] doの中に設定されているので、as:follower_pathではなく_customerも含まれる
    end
    resources :ideas, only: %i[new create edit update destroy] do
      resource :favorites, only: %i[create destroy]
    end
    resources :favorites, only: [] do
      get 'favorite_customers', on: :member, to: 'favorites#favorite_customers', as: 'customers'
    end
    resources :tags, only: [:index, :show]
    get "/search", to: "searches#search"
  end

  #adminのルーティング
  get 'admin', to:'admin/homes#top'
  namespace :admin do
    resources :customers, only: [:edit, :update]
  end

end
