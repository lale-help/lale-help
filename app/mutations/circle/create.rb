class Circle::Create < ::Form
  attribute :circle, :model, primary: true, default: proc{ Circle.new }, new_records: true
  attribute :user,   :model

  attribute :name,      :string
  attribute :location,  :string,  default: proc{ user.location.address }
  attribute :language,  :string, in: Circle.languages.keys

  def language_options
    Circle.languages.map do |key, val|
      [ I18n.t("language.#{key}"), key ]
    end
  end

  class Submit < ::Form::Submit
    def execute
      circle.assign_attributes inputs.slice(:name)
      circle.language = Circle.languages[language]
      circle.location = Location.location_from(location)

      circle.save

      Circle::Role.send('circle.admin').create(circle: circle, user: user)
      Circle::Role.send('circle.volunteer').create(circle: circle, user: user)

      user.update_attribute :primary_circle, circle

      circle
    end

  end
 end