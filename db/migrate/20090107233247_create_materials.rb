class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials, :force => true do |t|
      t.integer  :task_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.datetime :data_updated_at
    end
  end

  def self.down
    drop_table :materials
  end
end
