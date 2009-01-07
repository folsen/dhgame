class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes, :force => true do |t|
      t.string   :name
      t.text     :desc
      t.datetime :start_time
      t.integer  :headstart
      t.integer  :position
      t.integer  :headstart_count
    end
  end

  def self.down
    drop_table :episodes
  end
end
