class AddAdminAndUserData < ActiveRecord::Migration
  def self.up
      add_column :users, :team,         :string
      add_column :users, :nationality,  :string
      a = User.new(:name => "buffpojken", :password => "kexi", :password_confirmation => "kexi", :admin => 1)
      a.save!
  end

  def self.down
    remove_column :users, :team
    remove_column :users, :nationality
  end
end
