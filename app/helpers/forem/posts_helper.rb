module Forem
  module PostsHelper
    def avatar(user, options = {})
      if (email = user.try(:email)).present?
        image_tag(avatar_url(email, options), :alt => "Gravatar")
      end
    end

    def avatar_url(email, options = {})
      options = {:size => 60}.merge(options)
      require 'digest/md5' unless defined?(Digest::MD5)

      options[:s] = options.delete(:size)
      options[:d] = options.delete(:default) if options[:default]
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.strip.downcase)}?#{options.to_param}"
    end

  end
end
