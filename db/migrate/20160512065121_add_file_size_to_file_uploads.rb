class AddFileSizeToFileUploads < ActiveRecord::Migration
  def change
    add_column :file_uploads, :file_size_bytes, :integer
  end
end
