module SignInHelpers
  def sign_in(user)
    visit '/users/sign_in'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    page.should have_content("Signed in successfully")
  end

  def sign_out
    click_link 'Sign out'
    page.should have_content("Signed out successfully")
  end
end

RSpec.configure do |c|
  c.include SignInHelpers, :type => :request
end
