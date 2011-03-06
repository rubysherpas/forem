# def create_forum!(extra_attributes={})
#   attributes = {
#     :title => "Welcome to Forem!",
#     :description => "A placeholder forum."
#   }.merge!(extra_attributes)
# 
#   @forum = Forem::Forum.create!(attributes)
# end
# 
# def create_topic!(extra_attributes={})
#   attributes = { :subject => "FIRST TOPIC",
#     :posts_attributes => {
#       "0" => {
#         :text => "omgomgomg",
#         :user => User.first
#       }
#     }
#   }.merge!(extra_attributes)
# 
#   create_forum! unless @forum
#   @topic = @forum.topics.create(attributes)
#   @post = @topic.posts.first
#   @post.user = @user || create_user!
#   @post.save!
#   
#   @topic
# end
# 
# def create_user!(extra_attributes={})
#   attributes = {
#     :login => "forem_user"
#   }.merge!(extra_attributes)
# 
#   User.create!(attributes)
# end
# 
# def create_post!(extra_attributes={})
#   attributes = {
#     :text => "This is a brand new post!",
#     :user => @user || create_user!
#   }.merge!(extra_attributes)
#   
#   create_topic! unless @topic
#   @post = @topic.posts.create!(attributes)
# end