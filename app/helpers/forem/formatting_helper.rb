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
  end
end
