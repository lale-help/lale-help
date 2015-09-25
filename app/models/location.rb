class Location < ActiveRecord::Base
  has_many :circles
  has_many :users

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  def self.location_from(location_text)
    result = Geocoder.search(location_text).first
    if result.present?
      Location.find_or_create_by address: result.address, latitude: result.latitude, longitude: result.longitude
    end
  end
end
