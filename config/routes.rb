Forem::Engine.routes.draw do
  root :to => "forums#index"

  resources :forums, :only => [:index, :show] do
    resources :topics do
      member do
        get :subscribe
        get :unsubscribe
      end
    end

    member do
      get '/moderation', :to => "moderation#index", :as => :moderator_tools
    end
  end

  resources :topics do
    resources :posts
  end

  put 'forums/:forum_id/posts/:id/moderate', :to => "moderation#post", :as => :moderate_post

  resources :categories

  namespace :admin do
    root :to => "base#index"
    resources :groups do
      resources :members
    end

    resources :forums do
      resources :moderators
    end

    resources :categories
    resources :topics do
      member do
        put :toggle_hide
        put :toggle_lock
        put :toggle_pin
      end
    end

    get 'users/autocomplete', :to => "users#autocomplete"
  end
end
