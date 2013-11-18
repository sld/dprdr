class CreateLocalFiles < ActiveRecord::Migration
  def change
    create_table :local_files do |t|
      t.integer :book_id

      t.string :book_pdf
      t.string :book_djvu
      t.string :djvu_state

      t.timestamps
    end

    add_index :local_files, :book_id
  end
end
