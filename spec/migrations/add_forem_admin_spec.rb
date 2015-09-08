require 'spec_helper.rb'

Dir.chdir(Rails.root) do
 `rake railties:install:migrations`
end

require Dir.glob("#{Rails.root}/db/migrate/*add_forem_admin.forem.rb").first

describe AddForemAdmin do
  include_context "user migrations"
  
  it "adds forem_admin to user_class" do
    expect(subject).to receive('column_exists?').and_return(false)
    expect(subject).to receive('add_column').with(:users, :forem_admin, :boolean, {:default=>false})
    subject.change
  end
end