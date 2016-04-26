class FileUpload::CreateForm < ::Form
  attribute :file_upload, :model, primary: true, class: FileUpload, default: proc{ FileUpload.new }, new_records: true

  attribute :name,           :string
  attribute :uploader,       :model, class: User
  attribute :file,           :file
  attribute :is_public,      :boolean, default: false

  attribute :uploadable_gid, :string
  attribute :uploadable,     :model, class: ActiveRecord::Base

  attribute :redirect_path,  :string

  def uploadable
    @uploadable ||= GlobalID::Locator.locate(uploadable_gid)
  end


  class Submit < ::Form::Submit
    def execute
      FileUpload::Create.run!(inputs)
    end
  end
end