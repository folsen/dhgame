class AddLatestAttemptAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :latest_attempt_at, :datetime
  end

  def self.down
    remove_column :users, :latest_attempt_at
  end
end
