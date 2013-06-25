module Forem
  class ModerationToolsPresenter

    def initialize(context, post, mass_moderation)
      self.context = context
      self.post = post
      self.mass_moderation = mass_moderation
    end

    def to_s
      if self.mass_moderation
        with_mass_moderation
      else
        without_mass_moderation
      end
    end

    protected
    attr_accessor :context, :mass_moderation, :post
    delegate :forem, :form_tag, :render, :to => :context

    def without_mass_moderation
      form_tag forem.forum_moderate_posts_path(post.forum), :method => :put do
        render_moderation_tools
      end
    end

    def render_moderation_tools
      render '/forem/posts/moderation_tools', :post => post
    end
    alias_method :with_mass_moderation, :render_moderation_tools

  end
end
