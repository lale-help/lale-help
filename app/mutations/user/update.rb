class User::Update < ::Form
  attribute :user, :model, primary: true
  attribute :current_circle, :model, class: Circle

  attribute :first_name,        :string
  attribute :last_name,         :string
  attribute :mobile_phone,      :string, required: false
  attribute :home_phone,        :string, required: false
  attribute :email,             :string, matches: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  attribute :language,          :integer
  attribute :primary_circle_id, :integer
  attribute :about_me,          :string, required: false
  attribute :public_profile,    :boolean
  attribute :street_address_1,  :string, default: proc { user.address.try(:street_address_1) }, required: false
  attribute :city,              :string, default: proc { user.address.try(:city) },             required: false
  attribute :state_province,    :string, default: proc { user.address.try(:state_province) },   required: false
  attribute :postal_code,       :string, default: proc { user.address.try(:postal_code) },      required: false
  attribute :country,           :string, default: proc { user.address.try(:country) },          required: false
  attribute :accredited_until,          :date, required: false, format: I18n.t('circle.tasks.form.date_format')
  attribute :accredited_until_string,   :string, required: false, default: proc { stringify_date(circle_volunteer_role.accredited_until || Date.today + 2.years - 1.day) }
  attribute :profile_image, :file, required: false

  # required by refile in the form
  delegate :profile_image_attachment_definition, :profile_image_data, to: :user

  def circle_volunteer_role
    user.circle_volunteer_roles.find_by(circle: current_circle.id)
  end

  def accredited
    circle_volunteer_role.accredited?
  end

  def accredited_until_string=(string)
    self.accredited_until = parse_date(string)
  end

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

  def parse_date(string)
    string.present? && Date.strptime(string, I18n.t('circle.tasks.form.date_format'))
  end

  def stringify_date(date)
    date && date.strftime(I18n.t('circle.tasks.form.date_format'))
  end
  private :parse_date, :stringify_date

  class Submit < ::Form::Submit
    def validate
      add_error(:about_me, :too_long) if about_me.present? && about_me.length > 300
      add_error(:email, :taken)       if User::Identity.where(email: email).where.not(id: user.identity.id).exists?
    end

    def execute
      user.assign_attributes(inputs.slice(:first_name, :last_name, :mobile_phone, :home_phone, :language, :about_me, :public_profile))
      user.assign_attributes(inputs.slice(:primary_circle_id)) if user.has_multiple_circles?
      user.identity.assign_attributes(inputs.slice(:email))
      user.address.assign_attributes(inputs.slice(:street_address_1, :city, :state_province, :postal_code, :country))

      user.profile_image = profile_image if profile_image.present?
      user.save
      user.address.save
      user.identity.save
      circle_volunteer_role.update_attributes(inputs.slice(:accredited_until))
    end

    private

    # By convention, store the accredited_until only on the volunteer role.
    # It would be best to fix the DB structure. Only have one circle membership,
    # which stores the accredited_until flag; but joins in the roles, etc.
    def circle_volunteer_role
      user.circle_volunteer_roles.find_by(circle_id: inputs[:current_circle].id)
    end

  end
end
