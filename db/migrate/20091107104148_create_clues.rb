class CreateClues < ActiveRecord::Migration
  def self.up
    create_table :clues do |t|
      t.integer :task_id
      t.integer :position
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :clues
  end
end
