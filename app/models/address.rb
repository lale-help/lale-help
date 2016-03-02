class Address < ActiveRecord::Base
  has_one :user
  has_one :circle

  belongs_to :location

  before_save :update_location
  before_save :normalize_country

  def location_query
    [city, state_province, country].select{ |s| s.present? }.join(', ')
  end

  def full_address
    [street_address_1, city, state_province, postal_code, country].select{ |s| s.present? }.join(', ')
  end

  def update_location
    self.location = Location.location_from(full_address)
  end

  def normalize_country
    if self.country.present?
      normalized = (Carmen::Country.named(self.country) || Carmen::Country.coded(self.country)).try :code
      self.country = normalized if normalized.present?
    end
  end
end
