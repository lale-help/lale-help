class Location < ActiveRecord::Base
  geocoded_by :address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch address

  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }



  # Plz put me in some library! Thnx!
  def self.location_from(location_text)
    lat, lon = Geocoder.coordinates(location_text)
    Location.find_by(latitude: lat, longitude: lon) ||
        Location.create(address: location_text)
  end
end
