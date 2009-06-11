class AddTaskNameToWrongAnswer < ActiveRecord::Migration
  def self.up
    add_column :wrong_answers, :task_name, :string
  end

  def self.down
    remove_column :wrong_answers, :task_name
  end
end
