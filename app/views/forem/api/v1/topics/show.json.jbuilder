included = []

json.data do
  json.type "topics"
  json.(@topic, :id)
  json.attributes do
    json.(@topic, :subject, :user_id, :created_at, :views_count)
    json.posts_count relevant_posts(@topic).count
  end

  json.relationships do
    json.forum do
      json.data do
        json.type 'forums'
        json.(@forum, :id)
      end
    end

    json.posts do
      json.data @topic.posts do |post|
        included << post

        json.type 'posts'
        json.(post, :id)
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
      json.(object, :text, :user_id, :created_at)
    end
  end
end
