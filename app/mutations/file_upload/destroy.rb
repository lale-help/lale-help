class FileUpload::Destroy < Mutations::Command
  required do
    model :user
    model :file, class: FileUpload
  end

  def execute
    Rails.logger.info "User is destroying a file: user: #{user.id}  file: #{file.id}"
    file.destroy!
    FileUpload.directory.files.get(file.file_path).destroy
  end
end