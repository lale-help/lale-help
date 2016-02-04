class User::Create < ::Form
  attribute :user,     :model, new_records: true, primary: true, default: proc{ User.new }
  attribute :identity, :model, new_records: true, class: User::Identity, default: proc{ user.build_identity}

  attribute :first_name,        :string
  attribute :last_name,         :string
  attribute :email,             :string

  attribute :password,              :string
  attribute :password_confirmation, :string

  attribute :mobile_phone, :string, required: false
  attribute :home_phone, :string, required: false

  attribute :location, :string, required: false
  attribute :language, :integer
  
  attribute :public_profile, :boolean

  attribute :accept_terms, :boolean

  attribute :circle, :model, required: false

  def language_options
    User.languages.map do |key, val|
      [ I18n.t("language.#{key}"), val ]
    end
  end

  class Submit < ::Form::Submit
    def validate
      add_error(:password, :does_not_match) if password != password_confirmation
      add_error(:password, :too_short)      if password && password.length < 8

      add_error(:email, :taken) if User::Identity.where(email: email).exists?
      add_error(:accept_terms, :false) unless accept_terms == true
    end

    def execute
      user.assign_attributes(inputs.slice(:first_name, :last_name, :mobile_phone, :home_phone, :language, :public_profile))
      user.identity.assign_attributes(inputs.slice(:email, :password))

      user.location = Location.location_from(location)

      user.save
      user.identity.save

      Circle::Join.run(user: user, circle_id: circle.id) if circle.present?

      user
    end
  end
end