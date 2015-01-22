FactoryGirl.define do
  factory :forum_view, :class => Forem::View do
    association :user
    association :viewable, :factory => :forum
  end
  
  factory :topic_view, :class => Forem::View do
    association :user
    association :viewable, :factory => :topic
  end
end