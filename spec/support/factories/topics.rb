Factory.define(:topic, :class => Forem::Topic) do |t|
  t.subject "FIRST TOPIC"
  #t.association :forum
  t.forum {|f| f.association(:forum) }
  #t.posts { |p| [p.association(:post)] }
  #t.assocation :user
  t.user {|u| u.association(:user) }
end