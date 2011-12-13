module PermissionHelpers
  def access_denied!
    page.current_url.should == root_url
    flash_alert!(I18n.t('forem.access_denied'))
  end
end

RSpec.configure do |c|
  c.include PermissionHelpers, :type => :request
end
