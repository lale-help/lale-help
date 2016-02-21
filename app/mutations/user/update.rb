class User::Update < ::Form
  attribute :user, :model, primary: true

  attribute :first_name,        :string
  attribute :last_name,         :string
  attribute :mobile_phone,      :string, required: false
  attribute :home_phone,        :string, required: false
  attribute :email,             :string
  attribute :language,          :integer
  # attribute :primary_circle_id, :integer
  attribute :about_me,          :string, required: false
  attribute :public_profile,    :boolean
  attribute :street_address_1,  :string, default: proc { user.address.try(:street_address_1) }, required: false
  attribute :city,              :string, default: proc { user.address.try(:city) },             required: false
  attribute :state_province,    :string, default: proc { user.address.try(:state_province) },   required: false
  attribute :postal_code,       :string, default: proc { user.address.try(:postal_code) },      required: false
  attribute :country,           :string, default: proc { user.address.try(:country) },          required: false

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
      user.address.assign_attributes(inputs.slice(:street_address_1, :city, :state_province, :postal_code, :country))

      user.save
      user.address.save
      user.identity.save
    end
  end
end