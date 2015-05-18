class AdminSubscriber
  attr_reader :new_topic

  def initialize(topic)
    @topic = topic
  end

  def create
    @admins = Forem.user_class.where(
  end
end
