module Forem
  module PostsHelper
    def avatar(user, options = {})
      if (email = user.try(:email)).present?
        avatar_url(email, options).html_safe
      end
    end

    def avatar_url(email, options = {})
      options = {:size => 60}
      require 'digest/md5'
      size = ("?s=#{options[:size]}" if options[:size])
      "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.strip.downcase)}#{size}.jpg"
    end
  end
end
