class Sponsor::Create < Mutations::Command

  required do
    string  :name
    file    :image_file
    model   :current_user, class: User
  end

  optional do
    string  :url, empty: true, nils: true
    string  :description, empty: true, nils: true
  end

  # HACK need to use the url validator on the sponsor since Mutations can't use Rails validators
  def validate
    sponsor = Sponsor.new(inputs.slice(:name, :url, :description))
    sponsor.valid?
    if (sponsor.errors[:url].present?)
      add_error(:url, :invalid, sponsor.errors[:url].first)
    end
  end

  def execute
    sponsor = create_sponsor
    create_file_upload(sponsor)
    sponsor
  end

  private

  def create_sponsor
    sponsor = Sponsor.new(inputs.slice(:name, :url, :description))
    sponsor.save
    unless (sponsor.valid?)
      sponsor.errors.each { |k, v| add_error(k, :invalid, v) }
    end
    sponsor
  end

  def create_file_upload(sponsor)
    FileUpload::Create.run(
      file: image_file,
      is_public: true,
      upload_type: :sponsor_logo,
      uploader: current_user,
      uploadable: sponsor
    )
  end

end
