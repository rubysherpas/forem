# Force-decorate the User class in case it hasn't been yet. Fixes #495.
Forem.decorate_user_class!

Forem::Category.create(:name => 'General')

user = Forem.user_class.first
unless user.nil?
  forum = Forem::Forum.find_or_create_by(:category_id => Forem::Category.first.id, 
                               :name => "Default",
                               :description => "Default forem created by install")

  post = Forem::Post.find_or_initialize_by(text: "Hello World")
  post.user = user

  topic = Forem::Topic.find_or_initialize_by(subject: "Welcome to Forem")
  topic.forum = forum
  topic.user = user
  topic.posts = [ post ]

  topic.save!
end
