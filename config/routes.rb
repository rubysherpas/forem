Rails.application.routes.draw do
  namespace :forem do
    resources :forums do
      resources :topics, :as => "forem_topics"
    end
  end
end
