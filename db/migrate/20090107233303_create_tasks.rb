class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks, :force => true do |t|
      t.string   :name
      t.text     :desc
      t.integer  :episode_id
      t.datetime :created_at
      t.integer  :position
      t.string   :partial
    end
  end

  def self.down
    drop_table :tasks
  end
end
