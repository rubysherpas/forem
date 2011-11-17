module Forem
  module FormattingHelper
    # override with desired markup formatter, e.g. textile or markdown
    def as_formatted_html(text)
      if Forem.formatter
        Forem.formatter.format(text)
      else
        simple_format(h(text))
      end
    end

    def as_quoted_text(text)
      if Forem.formatter
        Forem.formatter.blockquote(text)
      else
         "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
      end
    end
  end
end
