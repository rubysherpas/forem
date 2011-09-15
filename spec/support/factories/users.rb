FactoryGirl.define do
  factory :user do |f|
    f.login "forem_user"
    f.email "bob@boblaw.com"

    factory :admin do |f|
      f.forem_admin true
    end
  end
end

