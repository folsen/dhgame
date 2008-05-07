class AddPartialFlags < ActiveRecord::Migration
  def self.up
    add_column :tasks, :partial, :string
  end

  def self.down
    remove_column :tasks, :partial
  end
end
