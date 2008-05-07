class CreateProgresses < ActiveRecord::Migration
  def self.up
    create_table :progresses do |t|
      t.column :task_id,      :integer
      t.column :episode_id,   :integer
      t.column :created_at,   :datetime
      t.column :answer,       :string
      t.column :user_id,      :integer
    end
  end

  def self.down
    drop_table :progresses
  end
end
