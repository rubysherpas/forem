# This class should be overriden by your application if you're using CanCan.
class Ability
  include CanCan::Ability
  def initialize(user)
  end

end
