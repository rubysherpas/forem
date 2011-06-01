module Forem
  module ApplicationHelper
    def forem_markdown(text, *options)
      text = sanitize(text) unless text.html_safe? || options.delete(:safe)
      (text.blank? ? "" : RDiscount.new(text).to_html).html_safe
    end
    
    def forem_theme_tag
      stylesheet_link_tag("forem/#{Forem::Engine.theme}/style.css")
    end
  end
end
