Rails.application.routes.draw do
  devise_for :users
  root :to => "home#index"
  get '/users/sign_in', :to => "devise/sessions#new", :as => "sign_in"
  get '/users/:id', :to => "users#show", :as => "user"

  mount Forem::Engine, :at => "/forem"
end
