Rails.application.routes.draw do
  namespace :admin do
    get 'customers/edit'
    get 'customers/update'
  end
  namespace :admin do
    get 'homes/top'
  end
  namespace :public do
    get 'rooms/create'
    get 'rooms/show'
  end
  namespace :public do
    get 'messages/create'
  end
  namespace :public do
    get 'searches/search'
  end
  namespace :public do
    get 'relationships/create'
    get 'relationships/destroy'
    get 'relationships/followers'
    get 'relationships/followeds'
  end
  namespace :public do
    get 'favorites/index'
    get 'favorites/create'
    get 'favorites/destroy'
  end
  namespace :public do
    get 'ideas/index'
    get 'ideas/new'
    get 'ideas/create'
    get 'ideas/edit'
    get 'ideas/update'
    get 'ideas/destroy'
    get 'ideas/tags'
    get 'ideas/search'
  end
  namespace :public do
    get 'customers/index'
    get 'customers/show'
    get 'customers/edit'
    get 'customers/update'
    get 'customers/out'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
  end
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
end
