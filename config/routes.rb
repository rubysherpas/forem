Rails.application.routes.draw do
  namespace :forem do
    resources :forums
  end
end
