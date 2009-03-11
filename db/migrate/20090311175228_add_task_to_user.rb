class AddTaskToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :task_id, :integer
  end

  def self.down
    remove_column :users, :task_id
  end
end
