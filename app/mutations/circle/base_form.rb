class Circle::BaseForm < ::Form
  attribute :circle, :model, primary: true, default: proc{ Circle.new }, new_records: true
  attribute :user,   :model

  attribute :name,      :string

  attribute :street_address_1,    :string, default: proc { circle.address.try(:street_address_1) }, required: false
  attribute :city,                :string, default: proc { circle.address.try(:city) }
  attribute :state_province,      :string, default: proc { circle.address.try(:state_province) },   required: false
  attribute :postal_code,         :string, default: proc { circle.address.try(:postal_code) }
  attribute :country,             :string, default: proc { circle.address.try(:country) }
  attribute :must_activate_users, :boolean, default: false


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
      circle.address.assign_attributes inputs.slice(:street_address_1, :city, :state_province, :postal_code, :country)

      circle.save

      circle
    end

  end
end