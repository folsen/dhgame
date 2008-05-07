class AddCrewToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :crew, :integer, :default => 0
  end

  def self.down
    remove_column :users, :crew
  end
end
