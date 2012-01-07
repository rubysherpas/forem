user = Forem.user_class.first
unless user.nil?
  forum = Forem::Forum.find_or_create_by_title( :category_id => Forem::Category.first.id, 
                               :title => "Default",
                               :description => "Default forem created by install")
  topic = Forem::Topic.find_or_create_by_subject( :forum_id => forum.id,
                               :user_id => user.id, 
                               :subject => "Welcome to forem!", 
                               :posts_attributes => [{:text => "Hello World", :user_id => user.id}])
end