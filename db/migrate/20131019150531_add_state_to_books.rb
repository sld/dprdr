class AddStateToBooks < ActiveRecord::Migration
  def change
    add_column :books, :djvu_state, :string
  end
end
