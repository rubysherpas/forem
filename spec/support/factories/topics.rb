FactoryGirl.define do
  factory :topic, :class => Forem::Topic do |t|
    t.subject "FIRST TOPIC"
    t.forum {|f| f.association(:forum) }
    t.user {|u| u.association(:user) }
    t.posts_attributes { [:text => "This is a brand new post"] }

    trait :approved do
      state 'approved'
    end

    factory :approved_topic, :traits => [:approved]
  end
end
