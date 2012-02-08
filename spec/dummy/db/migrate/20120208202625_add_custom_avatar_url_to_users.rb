class AddCustomAvatarUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :custom_avatar_url, :string
  end
end
