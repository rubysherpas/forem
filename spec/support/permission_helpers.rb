module PermissionHelpers
  def access_denied!
    expect(page.current_path).to eq(root_path)
    flash_alert!(I18n.t('forem.access_denied'))
  end
end

RSpec.configure do |c|
  c.include PermissionHelpers, :type => :feature
end
