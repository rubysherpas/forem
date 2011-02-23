# "Borrowed" from the context engine
class User
  attr_accessor :login, :forem_admin

  def initialize(attributes={})
    attributes.each do |k, v|
      self.send("#{k}=", v) if respond_to?("#{k}=")
    end
  end
  
  def to_s
    login
  end
end