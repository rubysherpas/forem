FactoryGirl.define do
  factory :user do |f|
    f.email "bob@boblaw.com"
    f.password "password"
    f.password_confirmation "password"

    factory :admin do |f|
      f.forem_admin true
    end
  end
end

