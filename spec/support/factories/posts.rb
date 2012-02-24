FactoryGirl.define do
  factory :post, :class => Forem::Post do |t|
    t.text "This is a brand new post!"
    t.user {|u| u.association(:user) }

    factory :approved_post do
      t.pending_review false
    end
  end
end
