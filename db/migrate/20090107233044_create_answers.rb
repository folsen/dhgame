class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers, :force => true do |t|
      t.string  :answer
      t.integer :task_id
    end
  end

  def self.down
    drop_table :answers
  end
end
