Forem::Engine.routes.draw do
  root :to => "forums#index"
  resources :forums do
    resources :topics
  end

  resources :topics do
    resources :posts
  end
end
