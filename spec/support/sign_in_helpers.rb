module SignInHelpers
  def sign_in(user)
    login_as(user)
    # visit '/users/sign_in'
    # fill_in 'Email', :with => user.email
    # fill_in 'Password', :with => 'password'
    # click_button 'Sign in'
    # page.should have_content("Signed in successfully")
  end

  def sign_out
    logout
  end
end

RSpec.configure do |c|
  c.include Warden::Test::Helpers
  c.include SignInHelpers, :type => :request
end
