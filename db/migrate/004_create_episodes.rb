class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.column :name,         :string
      t.column :desc,         :text
      t.column :start_time,   :datetime
      t.column :headstart,    :integer    
      t.column :position,     :integer
    end
  end

  def self.down
    drop_table :episodes
  end
end
