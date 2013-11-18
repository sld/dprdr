class MoveDjvuStateColumnToLocalFile < ActiveRecord::Migration
  def up
    add_column :local_files, :djvu_state, :string
    remove_column :books, :djvu_state
  end


  def down
    add_column :books, :djvu_state, :string
    remove_column :local_files, :djvu_state
  end
end
