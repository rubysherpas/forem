FactoryGirl.define do
  factory :forum, :class => Forem::Forum do |f|
    f.title "Welcome to Forem!"
    f.description "A placeholder forum."
  end
end