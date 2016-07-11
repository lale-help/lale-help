class Sponsor::Base < Mutations::Command

  # HACK need to use the Sponsor model's url validator since Mutations can't use Rails' validators directly
  def validate
    sponsor = Sponsor.new(url: url)
    sponsor.valid?
    if (sponsor.errors[:url].present?)
      add_error(:url, :invalid, sponsor.errors[:url].first)
    end
  end

  private

  def create_file_upload(sponsor)
    FileUpload::Create.run(
      file: image_file,
      is_public: true,
      upload_type: :sponsor_image,
      uploader: current_user,
      uploadable: sponsor
    )
  end

end
