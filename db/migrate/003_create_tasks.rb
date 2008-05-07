class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :name,           :string
      t.column :desc,           :text
      t.column :episode_id,     :integer
      t.column :created_at,     :datetime
      t.column :position,       :integer
    end
  end

  def self.down
    drop_table :tasks
  end
end
