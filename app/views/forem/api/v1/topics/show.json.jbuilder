included = []

json.data do
  json.type "topics"
  json.(@topic, :id)
  json.attributes do
    json.(@topic, :slug, :subject, :user_id, :created_at, :views_count)
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
  case object
  when Forem::Post
    json.partial! 'forem/api/v1/posts/post', post: object
  end
end
