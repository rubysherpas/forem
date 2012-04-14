FactoryGirl.define do
  factory :user do |f|
    f.login "forem_user"
    f.email { "bob#{rand(100000)}@boblaw.com" }
    f.password "password"
    f.password_confirmation "password"
    f.forem_auto_subscribe true

    factory :admin do |f|
      f.forem_admin true
    end
    
    factory :not_autosubscribed do |f|
      f.forem_auto_subscribe false
    end
  end
end

