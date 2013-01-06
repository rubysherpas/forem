FactoryGirl.define do
  factory :category, :class => Forem::Category do |f|
    f.name "Test Category"
  end
end