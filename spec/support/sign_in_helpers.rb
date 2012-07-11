module SignInHelpers
  def sign_in(user)
    login_as(user)
  end

  def sign_out
    logout
  end
end

RSpec.configure do |c|
  c.include Warden::Test::Helpers
  c.include SignInHelpers, :type => :request
end
