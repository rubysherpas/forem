module Forem
  class PostActionsPresenter

    def initialize(context, post, user)
      self.context = context
      self.post = post
      self.user = user
    end

    def to_s
      generate_links

      render_links
    end

    protected
    attr_accessor :context, :post, :user, :links
    delegate :can?, :content_tag, :forem, :link_to, :to => :context

    def links
      @links ||= []
    end

    def generate_links
      generate_reply_links if can?(:reply, post.topic) && post.topic.can_be_replied_to?
      generate_management_links if post.owner_or_admin?(user)
    end

    def generate_management_links
      if can?(:edit_post, post.forum)
        links << link_to(::I18n.t('edit', :scope => 'forem.post'), forem.edit_topic_post_path(post.topic, post))
      end
      links << link_to(
        ::I18n.t('delete', :scope => 'forem.topic'),
        forem.topic_post_path(post.topic, post), :method => :delete, :confirm => ::I18n.t("are_you_sure")
      )
    end

    def generate_reply_links
      links << link_to(
          ::I18n.t('reply', :scope => 'forem.topic'),
          forem.new_topic_post_path(post.topic, :reply_to_id => post.id)
        )
      links << link_to(
        ::I18n.t('quote', :scope => 'forem.topic'),
        forem.new_topic_post_path(post.topic, :reply_to_id => post.id, :quote => true)
      )
    end

    def render_links
      content_tag(:ul, :class => 'actions') do
        links.inject(ActiveSupport::SafeBuffer.new) do |buffer, link|
          buffer << content_tag(:li, link)
        end
      end
    end
  end
end
