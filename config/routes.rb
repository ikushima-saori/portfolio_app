Rails.application.routes.draw do

  #登録系で使うデバイスのルーティングを先に書く
  devise_for :admin, skip: [:registrations, :passwords], controllers: {  #新規登録とパス変更は使わない
    sessions: "admin/sessions"  #管理者が使うのはログインだけ
  }
  devise_for :customers,skip: [:passwords], controllers: {  #パス変更は使わない
    registrations: "public/registrations",
    sessions: 'public/sessions'  #ユーザーが使うのは新規登録とログイン
  }

  #publicのルーティング
  scope module: :public do
    root to: 'homes#top'
    get '/about', to:'homes#about', as:'about'
    get '/customers', to:'customers#index', as:'customers_index'
    get '/customers/my_page' => 'customers#show'
    get '/customers/information/edit' => 'customers#edit'
    patch '/customers/information' => 'customers#update'
    get '/customers/out' => 'customers#out'
    resources :relationships, only: %i[create destroy] do
      collection do
       get 'followers'
       get 'followeds'
      end
    end
    resources :ideas, only: %i[index new create edit update destroy] do
      collection do
        get 'tags'
        get 'search'
      end
      resource :favorites, only: %i[index create destroy]
    end
    resources :rooms, only: %i[show create]
    resources :messages, only: %i[create]
    get 'searches/search'
  end

  #adminのルーティング
  get 'admin', to: 'admin/homes#top'
  namespace :admin do
    resources :customers, only: [:edit, :update]
  end

end
