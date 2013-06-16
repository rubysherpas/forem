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

        image_tag "emoji/#{$1}.png", :alt => $1, :size => '20x20', :style => "vertical-align:middle"
      end.html_safe
    end

    protected
    attr_accessor :context, :content
    delegate :image_tag, :to => :context
  end
end
