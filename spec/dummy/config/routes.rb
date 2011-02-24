Rails.application.routes.draw do
  get '/sign_in', :controller => "fake", :action => "sign_in", :as => "sign_in"
  mount Forem::Engine, :at => "/forem"
end
