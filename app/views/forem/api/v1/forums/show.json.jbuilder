included = []

json.data do
  json.type "forums"
  json.id @forum.id
  json.attributes do
    json.(@forum, :title, :slug)
  end

  json.relationships do
    included += @topics

    api_has_many(json, :topics, 'topics', @topics) do |topic|
      last_post = relevant_posts(topic).last

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
  end
end

json.included included do |object|
  json.type object.class.name.demodulize.downcase.pluralize
  json.(object, :id)

  case object
  when Forem::Topic
    json.partial! 'forem/api/v1/topics/topic', topic: object
  when Forem::Post
    json.partial! 'forem/api/v1/posts/post', post: object
  end
end
