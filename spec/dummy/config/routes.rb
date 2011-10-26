Rails.application.routes.draw do
  devise_for :users
  root :to => "home#index"
  match '/users/sign_in', :to => "devise/sessions#new", :as => "sign_in"

  mount Forem::Engine, :at => "/forem"
end

