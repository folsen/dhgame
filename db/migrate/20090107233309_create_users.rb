class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string   :login,                     :limit => 40
      t.string   :firstname
      t.string   :lastname
      t.string   :phone
      t.string   :row
      t.string   :seat
      t.string   :team
      t.string   :nationality
      t.integer  :episode
      t.integer  :task
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at
      t.boolean  :crew,                                     :default => false
      t.boolean  :admin,                                    :default => false
      t.datetime :created_at
      t.datetime :updated_at
    end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  end

  def self.down
    drop_table :users
  end
end
