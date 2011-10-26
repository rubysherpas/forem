Rails.application.routes.draw do
  require 'devise/rails'
  devise_for :users

  mount Forem::Engine, :at => "/forem"
end
