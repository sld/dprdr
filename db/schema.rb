# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131120173119) do

  create_table "books", :force => true do |t|
    t.string   "name"
    t.string   "good_name"
    t.integer  "page"
    t.datetime "last_access"
    t.string   "bookcover"
    t.integer  "user_id"
    t.integer  "pages_count"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "dropbox_processing"
  end

  add_index "books", ["name"], :name => "index_books_on_name"
  add_index "books", ["user_id"], :name => "index_books_on_user_id"

  create_table "dropbox_files", :force => true do |t|
    t.datetime "modified"
    t.string   "size"
    t.integer  "revision"
    t.string   "path"
    t.string   "mime_type"
    t.integer  "book_id"
    t.string   "temp_file_path"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "local_files", :force => true do |t|
    t.integer  "book_id"
    t.string   "book_pdf"
    t.string   "book_djvu"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "djvu_state"
  end

  add_index "local_files", ["book_id"], :name => "index_local_files_on_book_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.boolean  "is_guest"
    t.string   "provider"
    t.string   "uid"
    t.string   "dropbox_token"
    t.string   "dropbox_folder"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
