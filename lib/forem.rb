require 'forem/engine'
require 'forem/default_permissions'
require 'kaminari'

module Forem
  mattr_accessor :user_class, :theme, :formatter, :default_gravatar, :default_gravatar_image,
                 :user_profile_links


  def self.user_class
    if @@user_class.is_a?(Class)
      warn("user_class will no longer take a Class object after January 20th, 2012."  +
            " Please pass the user_class= method a String object instead, like this:" +
            " Forem.user_class = 'User'. See http://github.com/radar/forem/issues/88" +
            " for an explanation why.")
      @@user_class
    elsif @@user_class.is_a?(String)
      @@user_class.constantize
    end
  end
end
