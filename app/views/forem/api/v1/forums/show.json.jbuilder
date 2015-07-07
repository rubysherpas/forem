json.data do
  json.type "forums"
  json.(@forum, :id)
  json.attributes do
    json.(@forum, :title, :slug)
  end
end

json.relationships do
  json.topics do
    json.data @forum.topics do |topic|
      json.type 'topics'
      json.(topic, :id)
    end
  end
end

json.included @forum.topics do |topic|
  json.type 'topics'
  json.(topic, :id)
  json.attributes do
    json.(topic, :subject)
  end
end
