json.errors @post.errors.full_messages do |message|
  json.title message
end
