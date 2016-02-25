class Address < ActiveRecord::Base
  has_many :users
  belongs_to :location

  def location_query
    [city, state_province, country].select{ |s| s.present? }.join(', ')
  end

  def full_address
    [street_address_1, city, state_province, postal_code, country].select{ |s| s.present? }.join(', ')
  end

end
