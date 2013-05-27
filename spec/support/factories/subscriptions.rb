FactoryGirl.define do
  factory :subscription, :class => Forem::Subscription do |f|
    association :subscriber, :factory => :user
    association :topic
  end
end