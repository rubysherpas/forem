require 'spec_helper.rb'

Dir.chdir(Rails.root) do
 `rake railties:install:migrations`
end

require Dir.glob("#{Rails.root}/db/migrate/*add_forem_auto_subscribe.forem.rb").first

describe AddForemAutoSubscribe do
  include_context "user migrations"
    
  it "adds forem_auto_subscribe to user_class" do
    subject.should_receive('column_exists?').and_return(false)
    subject.should_receive('add_column').with(:users, :forem_auto_subscribe, :boolean, {:default=>false})
    subject.change
  end
end