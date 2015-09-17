included = []

json.data do
  json.partial! 'forem/api/v1/topics/topic', topic: @topic

  if @posts
    json.relationships do
      api_has_many(json, :posts, 'posts', @posts)

      included += @posts
    end
  end
end

json.included included do |object|
  case object
  when Forem::Post
    json.partial! 'forem/api/v1/posts/post', post: object
  end
end
