module Forem
  module FormattingHelper
    # override with desired markup formatter, e.g. textile or markdown
    def as_formatted_html(text)
      if Forem.formatter
        Forem.formatter.format(as_sanitized_text(text))
      else
        Forem::Sanitizer.sanitize(text).html_safe
      end
    end

    def as_quoted_text(text)
      if Forem.formatter && Forem.formatter.respond_to?(:blockquote)
        Forem.formatter.blockquote(as_sanitized_text(text)).html_safe
      else
         "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
      end
    end

    def as_sanitized_text(text)
      if Forem.formatter.respond_to?(:sanitize)
        Forem.formatter.sanitize(text)
      else
        Forem::Sanitizer.sanitize(text)
      end
    end
  end
end
