class AddAttachmentsPdfToSolution < ActiveRecord::Migration
  def self.up
    add_column :solutions, :pdf_file_name, :string
    add_column :solutions, :pdf_content_type, :string
    add_column :solutions, :pdf_file_size, :integer
    add_column :solutions, :pdf_updated_at, :datetime
  end

  def self.down
    remove_column :solutions, :pdf_file_name
    remove_column :solutions, :pdf_content_type
    remove_column :solutions, :pdf_file_size
    remove_column :solutions, :pdf_updated_at
  end
end
