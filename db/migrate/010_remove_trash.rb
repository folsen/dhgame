class RemoveTrash < ActiveRecord::Migration
  def self.up
    remove_column :users, :episode
    remove_column :users, :task
  end

  def self.down
    add_column :users, :episode,  :integer
    add_column :users, :task,     :integer
  end
end
