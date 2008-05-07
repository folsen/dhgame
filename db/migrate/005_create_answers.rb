class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.column :answer,         :string
      t.column :task_id,        :integer
    end
  end

  def self.down
    drop_table :answers
  end
end
