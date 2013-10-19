class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.string :good_name
      t.integer :page, :default => 1
      t.datetime :last_access
      t.string :bookfile
      t.string :bookcover
      t.integer :user_id
      t.integer :pages_count

      t.timestamps
    end

    add_index :books, :user_id
    add_index :books, :name
  end
end
