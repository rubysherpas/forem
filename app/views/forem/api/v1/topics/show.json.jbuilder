included = []

json.data do
  json.type "topics"
  json.(@topic, :id)
  json.attributes do
    json.(@topic, :subject, :user_id, :created_at, :views_count)
    json.posts_count relevant_posts(@topic).count
  end

  last_post = relevant_posts(@topic).last

  if last_post
    included << last_post

    json.relationships do
      json.last_post do
        json.data do
          json.type 'posts'
          json.(last_post, :id)
        end
      end
    end
  end
end

json.included included do |object|
  json.type object.class.name.demodulize.downcase.pluralize
  json.(object, :id)

  json.attributes do
    case object
    when Forem::Post
      json.(object, :created_at)
    end
  end
end
