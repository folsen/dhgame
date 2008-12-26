class ChangeUsers < ActiveRecord::Migration
  def self.up
    drop_table "users"
    create_table "users", :force => true do |t|
      t.string :login,                      :limit => 40
      t.string :firstname              
      t.string :lastname                 
      t.string :phone  
      t.string :row
      t.string :seat     
      t.string :team
      t.string :nationality
      t.integer :episode
      t.integer :task       
      t.string :email,                      :limit => 100
      t.string :crypted_password,           :limit => 40
      t.string :salt,                       :limit => 40
      t.string :remember_token,             :limit => 40
      t.datetime :remember_token_expires_at
      t.boolean  :crew,                     :default => false
      t.boolean  :admin,                    :default => false
      
      t.timestamps

    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
    create_table "users", :force => true do |t|
      t.string   :name
      t.string   :hashed_password
      t.string   :salt
      t.string   :email
      t.string   :phone
      t.string   :first_name
      t.string   :last_name
      t.string   :row
      t.string   :seat
      t.integer  :admin,           :default => 0
      t.datetime :created_at
      t.integer  :crew,            :default => 0
      t.string   :team
      t.string   :nationality
    end
  end
end
