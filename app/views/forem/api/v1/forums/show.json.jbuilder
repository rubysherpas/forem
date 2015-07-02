json.data do
  json.type "forums"
  json.(@forum, :id)
  json.attributes do
    json.(@forum, :title, :slug)
  end
end