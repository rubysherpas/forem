Forem::Engine.routes.draw do
  root :to => "forums#index"

  resources :forums, :only => [:index, :show] do
    resources :topics do
      member do
        get :subscribe
        get :unsubscribe
      end
    end
  end

  resources :topics do
    resources :posts
  end

  resources :categories

  namespace :admin do
    root :to => "base#index"
    resources :forums
    resources :categories
    resources :topics do
      member do
        put :toggle_hide
        put :toggle_lock
        put :toggle_pin
      end
    end
  end
end
