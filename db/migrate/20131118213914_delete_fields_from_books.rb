class DeleteFieldsFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :bookfile
    remove_column :books, :bookfile_pdf
  end
end
