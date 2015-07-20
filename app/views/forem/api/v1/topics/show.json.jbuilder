included = []

json.data do
  json.type "topics"
  json.(@topic, :id)
  json.attributes do
    json.(@topic, :subject, :user_id, :created_at, :views_count)
    json.posts_count relevant_posts(@topic).count
  end

  json.relationships do
    api_has_one(json, :user, 'users', @topic.user_id)
    api_has_one(json, :forum, 'forums', @topic.forum_id)
    api_has_many(json, :posts, 'posts', @topic.posts)

    included += @topic.posts
  end
end

json.included included do |object|
  json.type object.class.name.demodulize.downcase.pluralize
  json.(object, :id)

  json.attributes do
    case object
    when Forem::Post
      json.(object, :text, :created_at)
    end
  end

  json.relationships do
    case object
    when Forem::Post
      api_has_one(json, :user, 'users', object.user_id)
    end
  end
end
