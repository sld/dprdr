class CreateDropboxFiles < ActiveRecord::Migration
  def change
    create_table :dropbox_files do |t|
      t.datetime :modified
      t.string :size
      t.integer :revision
      t.string :path
      t.string :mime_type
      t.integer :book_id

      t.timestamps
    end
  end
end
