class CreateWrongAnswers < ActiveRecord::Migration
  def self.up
    create_table :wrong_answers do |t|
      t.string :answer
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end

  def self.down
    drop_table :wrong_answers
  end
end
