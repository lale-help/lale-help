class CreateFileUploads < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :file_uploads, id: :uuid do |t|
      t.string :file_name
      t.string :file_path
      t.string :file_content_type
      t.string :file_extension
      t.string :file_encryption_details

      t.boolean :is_public, default: false

      t.string  :uploadable_type
      t.integer :uploadable_id

      t.timestamps null: false
    end
  end
end
