class CreateSolutions < ActiveRecord::Migration
  def self.up
    create_table :solutions do |t|
      t.datetime :release_at
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :solutions
  end
end
