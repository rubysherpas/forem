FactoryGirl.define do
  factory :topic_view, :class => Forem::View do |f|
    association :user
    association :viewable, :factory => :topic
  end
end