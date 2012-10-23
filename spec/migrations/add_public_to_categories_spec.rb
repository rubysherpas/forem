require 'spec_helper.rb'

Dir.chdir(Rails.root) do
 `rake railties:install:migrations`
end

require Dir.glob("#{Rails.root}/db/migrate/*add_public_to_categories.forem.rb").first

describe AddPublicToCategories do
  include_context "user migrations"
  
  it "adds public to forem_categories" do
    subject.should_receive('column_exists?').and_return(false)
    subject.should_receive('add_column').with(:forem_categories, :public, :boolean, {:default=>false})
    subject.change
  end
end