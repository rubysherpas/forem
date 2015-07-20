json.data do
  json.type "posts"
  json.(@post, :id)
  json.attributes do
    json.(@post, :text, :user_id, :created_at)
  end

  json.relationships do
    json.topic do
      json.data do
        json.type 'topics'
        json.(@topic, :id)
      end
    end

    json.forum do
      json.data do
        json.type 'forums'
        json.(@topic.forum, :id)
      end
    end
  end
end
