class Sponsor::Create < Sponsor::Base

  required do
    string  :name
    file    :image_file
    model   :current_user, class: User
  end

  optional do
    string  :url, empty: true, nils: true
    string  :description, empty: true, nils: true
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

end
