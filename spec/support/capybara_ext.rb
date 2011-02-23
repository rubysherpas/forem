module CapybaraExt
  # Just a shorter way of writing it.
  def assert_seen(text, opts={})
    if opts[:within]
      within(opts[:within]) do
        page.should have_content(text)
      end
    else
      page.should have_content(text)
    end
  end
  
  def flash_error!(text)
    within("#flash_error") do
      assert_seen(text)
    end
  end
  
  def flash_notice!(text)
    within("#flash_notice") do
      assert_seen(text)
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraExt
end