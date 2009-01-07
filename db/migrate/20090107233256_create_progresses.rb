class CreateProgresses < ActiveRecord::Migration
  def self.up
    create_table :progresses, :force => true do |t|
      t.integer  :task_id
      t.integer  :episode_id
      t.datetime :created_at
      t.string   :answer
      t.integer  :user_id
      t.integer  :position
    end
  end

  def self.down
    drop_table :progresses
  end
end
