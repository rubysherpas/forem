# Thanks to plataformatec/devise
# The code used to inspire this generator!
require 'rails/generators'
module Forem
  module Generators
    class ViewsGenerator < Rails::Generators::Base #:nodoc:
      source_root File.expand_path("../../../../app/views/forem", __FILE__)
      desc "Used to copy forem's views to your application's views."

      def copy_views
        view_directory :admin
        view_directory :categories
        view_directory :forums
        view_directory :moderation
        view_directory :posts
        view_directory :subscription_mailer
        view_directory :topics
      end

      protected

      def view_directory(name)
        directory name.to_s, "app/views/forem/#{name}"
      end
    end
  end
end
