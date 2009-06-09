class AddLoginToWrongAnswer < ActiveRecord::Migration
  def self.up
    add_column :wrong_answers, :login, :string
  end

  def self.down
    remove_column :wrong_answers, :login
  end
end
