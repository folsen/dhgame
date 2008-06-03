class AddHeadstartCount < ActiveRecord::Migration
  def self.up
    add_column :episodes, :headstart_count, :integer
  end

  def self.down
    remove_column :episodes, :headstart_count
  end
end
