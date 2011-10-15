module Forem
  module FormattingHelper
    # override with desired markup formatter, e.g. textile or markdown
    def as_formatted_html(text)
      raw('<pre>')+h(text)+raw('</pre>')
    end
  end
end
