Forem::Engine.routes.draw do
  root :to => "forums#index"

  # resources :topics, :only => [:new, :create, :index, :show, :destroy] do
  #   resources :posts
  # end

  resources :categories, :only => [:index, :show]

  namespace :admin do
    root :to => "base#index"
    resources :groups do
      resources :members, only: [:destroy] do
        collection do
          post :add
        end
      end
    end

    resources :forums do
      resources :moderators
      resources :topics do
        member do
          put :toggle_hide
          put :toggle_lock
          put :toggle_pin
        end
      end
    end

    resources :categories

    get 'users/autocomplete', :to => "users#autocomplete", :as => "user_autocomplete"
  end

  get '/:forum_id/moderation', :to => "moderation#index", :as => :forum_moderator_tools
  # For mass moderation of posts
  put '/:forum_id/moderate/posts', :to => "moderation#posts", :as => :forum_moderate_posts
  # Moderation of a single topic
  put '/:forum_id/topics/:topic_id/moderate', :to => "moderation#topic", :as => :moderate_forum_topic

  resources :forums, :only => [:index, :show], :path => "/" do
    resources :topics, :except => :index do
      resources :posts, :except => :index
      member do
        post :subscribe
        post :unsubscribe
      end
    end
  end
end
