class AddDropboxProcessingToBooks < ActiveRecord::Migration
  def change
    add_column :books, :dropbox_processing, :boolean
  end
end
