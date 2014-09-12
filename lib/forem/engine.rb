module ::Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end

    config.to_prepare do
      Decorators.register! Engine.root, Rails.root
    end

    # Precompile any assets included straight in certain pges
    initializer "forem.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        forem/admin/members.js
      ]
    end
  end
end

require 'simple_form'
require 'emoji'
require 'select2-rails'

# We need one of the two pagination engines loaded by this point.
# We don't care which one, just one of them will do.
begin
  require 'kaminari'
rescue LoadError
  begin
    require 'will_paginate'
  rescue LoadError
   puts "Please add the kaminari or will_paginate gem to your application's Gemfile. The Forem engine needs either kaminari or will_paginate in order to paginate."
   exit
  end
end
