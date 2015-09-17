included = []

json.data do
  json.partial! 'forem/api/v1/topics/topic', topic: @topic

  json.relationships do
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
