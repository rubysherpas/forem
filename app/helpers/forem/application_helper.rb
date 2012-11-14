module Forem
  module ApplicationHelper
    include FormattingHelper
    # processes text with installed markup formatter
    def forem_format(text, *options)
      forem_emojify(as_formatted_html(text))
    end

    def forem_quote(text)
      as_quoted_text(text)
    end

    def forem_markdown(text, *options)
      #TODO: delete deprecated method
      Rails.logger.warn("DEPRECATION: forem_markdown is replaced by forem_format() + forem-markdown_formatter gem, and will be removed")
      forem_format(text)
    end

    def forem_pages_widget(collection)
      if collection.num_pages > 1
        content_tag :div, :class => 'pages' do
          (t('forem.common.pages') + ':' + forem_paginate(collection)).html_safe
        end
      end
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

    def forem_atom_auto_discovery_link_tag  
      if controller_name == "topics" && action_name == "show"
        auto_discovery_link_tag(:atom)
      end
    end

    def forem_emojify(content)
      h(content).to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
        if Emoji.names.include?($1)
          '<img alt="' + $1 + '" height="20" src="' + asset_path("emoji/#{$1}.png") + '" style="vertical-align:middle" width="20" />'
        else
          match
        end
      end.html_safe if content.present?
    end
  end
end
