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

  resources :topics, :only => [:new, :create, :index, :show, :destroy] do
    resources :posts
  end

  get 'forums/:forum_id/moderation', :to => "moderation#index", :as => :forum_moderator_tools
  # For mass moderation of posts
  put 'forums/:forum_id/moderate/posts', :to => "moderation#posts", :as => :forum_moderate_posts
  # Moderation of a single topic
  put 'forums/:forum_id/topics/:topic_id/moderate', :to => "moderation#topic", :as => :moderate_forum_topic

  resources :categories, :only => [:index, :show]

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
