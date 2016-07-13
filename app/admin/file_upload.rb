ActiveAdmin.register FileUpload, as: 'File' do

  index do
    selectable_column
    column :id
    column :upload_type
    column :uploader
    column :uploadable
    column "Size (KB)" do |file|
      begin
        (file.file_size_bytes / 1024.0).round
      rescue
        ""
      end
    end
    column :created_at
    actions
  end

end
