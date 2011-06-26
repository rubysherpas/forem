Forem::Engine.routes.draw do
  root :to => "forums#index"

  resources :forums, :only => [:index, :show] do
    resources :topics
  end

  resources :topics do
    resources :posts
  end

  namespace :admin do
    root :to => "base#index"
    resources :forums
    resources :topics do
      member do
        put :toggle_hide
      end
    end
  end
end
