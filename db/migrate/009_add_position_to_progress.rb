class AddPositionToProgress < ActiveRecord::Migration
  def self.up
    add_column :progresses, :position, :integer
  end

  def self.down
    remove_column :progresses, :position
  end
end
