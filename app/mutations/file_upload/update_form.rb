class FileUpload::UpdateForm < ::Form
  attribute :file_upload, :model, primary: true, class: FileUpload

  attribute :name,           :string
  attribute :is_public,      :boolean, default: false

  attribute :redirect_path,  :string

  def uploadable
    @uploadable ||= GlobalID::Locator.locate(uploadable_gid)
  end


  class Submit < ::Form::Submit
    def execute
      file_upload.name        = name
      file_upload.is_public   = is_public
      file_upload.save!
      file_upload
    end
  end
end