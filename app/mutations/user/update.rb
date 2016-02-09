class User::Update < ::Form
  attribute :user, :model, primary: true

  attribute :first_name,        :string
  attribute :last_name,         :string
  attribute :mobile_phone,      :string, required: false
  attribute :home_phone,        :string, required: false
  attribute :email,             :string
  attribute :location,          :string, default: proc { user.location.try(:address) }
  attribute :language,          :integer
  attribute :primary_circle_id, :integer
  attribute :about_me,          :string
  attribute :public_profile,    :boolean
  
  def language_options
    User.languages.map do |key, val|
      [ I18n.t("language.#{key}"), val ]
    end
  end

  def primary_circle_options
    user.circles.order('name ASC')
  end

  class Submit < ::Form::Submit
    def validate
      add_error(:about_me, :too_long) if about_me.length > 300
    end

    def execute
      user.assign_attributes(inputs.slice(:first_name, :last_name, :mobile_phone, :home_phone, :language, :about_me, :public_profile))
      user.identity.assign_attributes(inputs.slice(:email))

      user.location = Location.location_from(location)
      user.primary_circle = user.circles.find(primary_circle_id)

      user.save
      user.identity.save
    end
  end
end