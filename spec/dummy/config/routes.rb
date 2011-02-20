Rails.application.routes.draw do
  match "forem", :to => Forem::Engine, :controller => "hax"
end
