module SignInHelpers
  def sign_in(user)
    visit '/users/sign_in'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
  end
end

RSpec.configure do |c|
  c.include SignInHelpers, :type => :request
end
