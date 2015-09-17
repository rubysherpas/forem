json.type "topics"
json.(topic, :id)
json.attributes do
  json.(topic, :slug, :subject, :views_count, :created_at)
  json.posts_count relevant_posts(topic).count
end

json.relationships do
  api_has_one(json, :user, 'users', topic.user_id)
  api_has_one(json, :forum, 'forums', topic.forum_id)
end
