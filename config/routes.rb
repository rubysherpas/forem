Forem::Engine.routes.draw do
  resources :forums do
    resources :topics
  end

  resources :topics do
    resources :posts
  end
end
