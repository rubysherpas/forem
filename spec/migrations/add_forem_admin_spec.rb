require 'spec_helper.rb'
require 'support/shared_context_for_migrations.rb'

Dir.chdir(Rails.root) do
 `rake railties:install:migrations`
end

require Dir.glob("#{Rails.root}/db/migrate/*add_forem_admin.forem.rb").first

describe AddForemAdmin do
  include_context "user migrations"
  
  it "adds forem_admin to user_class" do
    subject.should_receive('column_exists?').and_return(false)
    subject.should_receive('add_column').with(:users, :forem_admin, :boolean, {:default=>false})
    subject.change
  end
end