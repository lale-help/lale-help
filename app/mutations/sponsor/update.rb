class Sponsor::Update < Sponsor::Base

  required do
    string  :name
    model   :sponsor
    model   :current_user, class: User
  end

  optional do
    file    :image_file
    string  :url, empty: true, nils: true
    string  :description, empty: true, nils: true
  end

  required do
  end

  def execute
    update_sponsor
    update_file_upload if image_file
    sponsor
  end

  def update_sponsor
    sponsor.update_attributes(inputs.slice(:name, :url, :description))
  end

  def update_file_upload
    # out with the old
    sponsor.image.destroy
    # in with the new
    create_file_upload(sponsor)
  end
end
