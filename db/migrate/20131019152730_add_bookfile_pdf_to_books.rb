class AddBookfilePdfToBooks < ActiveRecord::Migration
  def change
    add_column :books, :bookfile_pdf, :string
  end
end
