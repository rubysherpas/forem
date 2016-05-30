json.type "posts"
json.(post, :id)
json.attributes do
  json.(post, :text, :created_at)
end

json.relationships do
  api_has_one(json, :user, 'users', post.user_id)
  api_has_one(json, :topic, 'topics', post.topic_id)
  api_has_one(json, :forum, 'forums', post.forum.id)
end
