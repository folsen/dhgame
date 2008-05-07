class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name,                 :string
      t.column :hashed_password,      :string
      t.column :salt,                 :string
      t.column :email,                :string
      t.column :phone,                :string
      t.column :first_name,           :string
      t.column :last_name,            :string
      t.column :row,                  :string
      t.column :seat,                 :string
      t.column :episode,              :integer,      :default => 0
      t.column :task,                 :integer  ,      :default => 0
      t.column :admin,                :integer,     :default => 0
      t.column :created_at,           :datetime
    end
  
      add_index :users, :name
  end
  

  def self.down
    drop_table :users
  end
end
