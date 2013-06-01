FactoryGirl.define do
  factory :topic, :class => Forem::Topic do |t|
    t.subject "FIRST TOPIC"
    t.forum {|f| f.association(:forum) }
    t.user {|u| u.association(:user) }
    t.posts_attributes { [:text => "This is a brand new post"] }

    factory :approved_topic do
      after_create do |t|
        t.approve!
      end
    end
  end
end
