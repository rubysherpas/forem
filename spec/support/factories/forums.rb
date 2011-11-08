FactoryGirl.define do
  factory :forum, :class => Forem::Forum do |f|
    f.title "Welcome to Forem!"
    f.description "A placeholder forum."
    f.category {|t| t.association(:category) }
  end
end