module CapybaraExt
  # login helper
  def sign_in(user)
    page.driver.post "/users/sign_in", :user => {
      :email => user.email, :password => user.password
    }
  end

  def sign_out
    page.driver.delete "/users/sign_out"
  end

  # Just a shorter way of writing it.
  def assert_seen(text, opts={})
    if opts[:within]
      within(selector_for(opts[:within])) do
        page.should have_content(text)
      end
    else
      page.should have_content(text)
    end
  end

  def assert_no_link_for!(id_or_text)
    lambda { find_link(id_or_text) }.should(raise_error(Capybara::ElementNotFound), "Expected there not to be a link for #{id_or_text.inspect} on page, but there was")
  end

  def flash_alert!(text)
    within("#flash_alert") do
      assert_seen(text)
    end
  end

  def flash_notice!(text)
    within("#flash_notice") do
      assert_seen(text)
    end
  end

  def selector_for(identifier)
    case identifier
    when :forum_header
      "#forum h2"
    when :forum_description
      "#forum .description"
    when :topic_header
      "#topic h2"
    when :topic_menu
      "#topic menu"
    when :post_text
      "#posts .post"
    when :post_user
      "#posts .post .user"
    when :first_post
      "#posts #post_1"
    when :second_post
      "#posts #post_2"
    when :post_actions
      "#{selector_for(:first_post)} .actions"
    when :topic_moderation
      "#topic .moderation"
    when :post_moderation
      ".post .moderation"
    when :started_by
      ".started-by"
    else
      pending "No selector defined for #{identifier}. Please define one in spec/support/capybara_ext.rb"
    end
  end

  # Just shorter to type.
  def page!
    save_and_open_page
  end
end

RSpec.configure do |config|
  config.include CapybaraExt
end
