Forem::Engine.routes.draw do
  resources :forums do
    resources :topics
  end
end
