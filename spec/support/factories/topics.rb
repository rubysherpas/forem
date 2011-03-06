Factory.define(:topic, :class => Forem::Topic) do |t|
  t.subject "FIRST TOPIC"
  t.forum {|f| f.association(:forum) }
  t.user {|u| u.association(:user) }
  t.posts { |p| [p.association(:post)]}
end