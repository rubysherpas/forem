FactoryGirl.define do
  factory :user do |f|
    f.login "forem_user"
    f.email { "bob#{rand(100000)}@boblaw.com" }
    f.password "password"
    f.password_confirmation "password"

    factory :admin do |f|
      f.forem_admin true
    end
  end
end

