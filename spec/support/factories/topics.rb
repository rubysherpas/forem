FactoryGirl.define do
  factory :topic, :class => Forem::Topic do |t|
    t.subject "FIRST TOPIC"
    t.forum {|f| f.association(:forum) }
    t.user {|u| u.association(:user) }
    t.posts { |p| [p.association(:post)]}

    trait :approved do
      after_create { |topic| topic.approve! }
    end

    factory :approved_topic, :traits => [:approved]
  end
end
