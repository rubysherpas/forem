FactoryGirl.define do
  factory :subscription, :class => Forem::Subscription do
    association :subscriber, :factory => :user
    association :topic
  end
end