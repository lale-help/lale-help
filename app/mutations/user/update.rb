class User::Update < ::Form
  attribute :user, :model, primary: true

  attribute :first_name,        :string
  attribute :last_name,         :string
  attribute :mobile_phone,      :string, required: false, nils: true, empty: true
  attribute :home_phone,        :string, required: false, nils: true, empty: true
  attribute :email,             :string
  # attribute :location,          :string, default: proc { user.location.try(:address) }
  attribute :language,          :integer
  # attribute :primary_circle_id, :integer
  attribute :about_me,          :string, required: false, nils: true, empty: true
  attribute :public_profile,    :boolean
  attribute :street_address,    :string, default: proc { user.location.try(:street_address) }, required: false
  attribute :city,              :string, default: proc { user.location.try(:city) }, required: false
  attribute :state,             :string, default: proc { user.location.try(:state) }, required: false
  attribute :postal_code,       :string, default: proc { user.location.try(:postal_code) }, required: false
  attribute :country_code,      :string, default: proc { user.location.try(:country_code) }, required: false

  def language_options
    User.languages.map do |key, val|
      [ I18n.t("language.#{key}"), val ]
    end
  end

  def primary_circle_options
    user.circles.order('name ASC')
  end

  def email
    (@email || user.email).downcase
  end

  class Submit < ::Form::Submit
    def validate
      add_error(:about_me, :too_long) if about_me.present? && about_me.length > 300
      add_error(:email, :taken)       if User::Identity.where(email: email).where.not(id: user.identity.id).exists?
    end

    def execute
      user.assign_attributes(inputs.slice(:first_name, :last_name, :mobile_phone, :home_phone, :language, :about_me, :public_profile))
      user.identity.assign_attributes(inputs.slice(:email))

      user.location.assign_attributes(inputs.slice(:street_address, :city, :state, :postal_code, :country_code))
      # user.location = Location.location_from(user.location.address_from_components)
      # user.primary_circle = user.circles.find(primary_circle_id)

      user.save
      user.location.save
      user.identity.save
    end
  end
end