module Forem
  module ApplicationHelper
    def forem_markdown(text, *options)
      text = sanitize(text) unless text.html_safe? || options.delete(:safe)
      (text.blank? ? "" : RDiscount.new(text).to_html).html_safe
    end

    def forem_paginate(collection, options={})
      if respond_to?(:will_paginate)
        # If parent app is using Will Paginate, we need to use it also
        will_paginate collection, options
      else
        # Otherwise use Kaminari
        paginate collection, options
      end
    end
  end
end
