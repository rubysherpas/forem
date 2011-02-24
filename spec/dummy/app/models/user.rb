class User < ActiveRecord::Base

  def to_s
    login
  end
end