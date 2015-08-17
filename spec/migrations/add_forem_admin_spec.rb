require 'spec_helper.rb'

Dir.chdir(Rails.root) do
 `rake railties:install:migrations`
end

require Dir.glob("#{Rails.root}/db/migrate/*add_forem_admin.forem.rb").first

describe AddForemAdmin do
  include_context "user migrations"
  
  it "adds forem_admin, forem_state, and forem_auto_subscribe to user_class" do
    subject.stub("add_column").with(anything())
    subject.stub("column_exists?").with(anything())
    subject.should_receive('column_exists?').with(:users, :forem_admin).and_return(false)
    subject.should_receive('add_column').with(:users, :forem_admin, :boolean, {:default=>false})
    subject.should_receive('column_exists?').with(:users, :forem_state).and_return(false)
    subject.should_receive('add_column').with(:users, :forem_state, :string, {:default=>"pending_review"})
    subject.should_receive('column_exists?').with(:users, :forem_auto_subscribe).and_return(false)
    subject.should_receive('add_column').with(:users, :forem_auto_subscribe, :boolean, {:default=>false})
    subject.change
  end
end