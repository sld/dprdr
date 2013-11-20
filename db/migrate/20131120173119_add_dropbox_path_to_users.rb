class AddDropboxPathToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_folder, :string
  end
end
