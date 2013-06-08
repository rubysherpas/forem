require 'emoji'
require 'erb'
require 'active_support/core_ext/string/output_safety'

module Forem
  class EmojiPresenter

    def initialize(context, content)
      self.context = context
      self.content = content
    end

    def to_s
      ERB::Util.h(self.content).to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
        return match unless Emoji.names.include?($1)

        %Q{<img alt="#{$1}" height="20" src="#{context.asset_path("emoji/#{$1}.png")}" style="vertical-align:middle" width="20" />}
      end.html_safe
    end

    protected
    attr_accessor :context, :content
  end
end
