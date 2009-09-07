# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090611205048) do

  create_table "answers", :force => true do |t|
    t.string  "answer"
    t.integer "task_id"
  end

  create_table "episodes", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "start_time"
    t.integer  "headstart"
    t.integer  "position"
    t.integer  "headstart_count"
  end

  create_table "materials", :force => true do |t|
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  create_table "progresses", :force => true do |t|
    t.integer  "task_id"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.string   "answer"
    t.integer  "user_id"
    t.integer  "position"
  end

  create_table "solutions", :force => true do |t|
    t.datetime "release_at"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.integer  "position"
    t.string   "partial"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.string   "row"
    t.string   "seat"
    t.string   "team"
    t.string   "nationality"
    t.integer  "episode"
    t.integer  "task"
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "crew",                                     :default => false
    t.boolean  "admin",                                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "wrong_answers", :force => true do |t|
    t.string   "answer"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "task_name"
  end

end
