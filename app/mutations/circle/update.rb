class Circle::Update < ::Form
  attribute :circle, :model, primary: true
  attribute :user,   :model

  attribute :name,      :string
  attribute :location,  :string,  default: proc{ circle.location.address }

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

      circle
    end

  end
 end