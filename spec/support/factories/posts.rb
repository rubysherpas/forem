FactoryGirl.define do
  factory :post, :class => Forem::Post do |t|
    t.text "This is a brand new post!"
    t.user {|u| u.association(:user) }

    trait :approved do
      pending_review false
    end

    factory :approved_post, :traits => [:approved]
  end

end
