require 'sanitize'

# This is exists so formatters can access it if it so pleases them.
module Forem
  class Sanitizer
    def self.sanitize(text)
      Sanitize.clean(text, :elements => ['h1', 'h2', 'h3', 'h4', 'h5', 'h6',
        'b', 'i', 'p', 'small', 'u', 'span', 'blockquote', 'ul', 'ol', 'li'],
        :attributes => {'span' => ['class']})
    end
  end
end
