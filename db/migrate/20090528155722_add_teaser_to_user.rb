class AddTeaserToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :teaser, :string
  end

  def self.down
    remove_column :users, :teaser
  end
end
