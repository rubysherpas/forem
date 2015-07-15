json.data do
  json.type "posts"
  json.(@post, :id)
  json.attributes do
    json.(@post, :text, :user_id, :created_at)
  end
end
