module Forem
  module PostsHelper
    def avatar(user='')
      email = user.try(:email)
      gravatar_image_tag(email, :gravatar => { :default => :identicon }).html_safe if email.present?
    end
  end
end
