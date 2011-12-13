require 'forem/engine'
require 'forem/default_permissions'
require 'kaminari'

module Forem
  mattr_accessor :user_class, :theme, :formatter, :default_gravatar, :default_gravatar_image,
                 :user_profile_links

end
