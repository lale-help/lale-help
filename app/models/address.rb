class Address < ActiveRecord::Base
  has_one :user
  has_one :circle

  belongs_to :location

  before_save :update_location

  def location_query
    [city, state_province, country].select{ |s| s.present? }.join(', ')
  end

  def full_address
    [street_address_1, city, state_province, postal_code, country].select{ |s| s.present? }.join(', ')
  end

  def update_location
    self.location = Location.location_from(full_address)
  end
end
