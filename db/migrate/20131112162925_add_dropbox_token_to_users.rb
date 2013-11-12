class AddDropboxTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_token, :string
  end
end
