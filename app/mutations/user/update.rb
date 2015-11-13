class User::Update < ::Form
  attribute :user, :model, primary: true

  attribute :first_name,  :string
  attribute :last_name,   :string
  attribute :email,       :string
  attribute :location,    :string
  attribute :language,    :integer

  def location
    @location ||= user.location.geocode_query if user.location.present?
  end

  def email
    @email ||= user.identity.email if user.identity.present?
  end

  def language_options
    User.languages.map do |key, val|
      [ I18n.t("language.#{key}"), val ]
    end
  end

  class Submit < ::Form::Submit
    def execute
      user.assign_attributes(inputs.slice(:first_name, :last_name, :language))
      user.identity.assign_attributes(inputs.slice(:email))

      user.location = Location.location_from(location)

      user.save
      user.identity.save
    end
  end
end