class Location < ActiveRecord::Base
  has_many :circles
  has_many :users
  has_many :task_assignments, class_name: "Task::LocationAssignment"
  has_many :tasks, through: :task_assignments

  geocoded_by :geocode_query
  reverse_geocoded_by :latitude, :longitude

  def self.location_from(location_text)
    previous_locaion = Location.find_by('lower(geocode_query) = ?', location_text.downcase)
    if previous_locaion.present?
      Rails.logger.debug "[Location] cache hit"
      return previous_locaion
    end

    Rails.logger.debug "[Location] cache miss"
    response = Geocoder.search(location_text).first

    if response.present?
      Location.create geocode_query: location_text, geocode_data: response.data, latitude: response.latitude, longitude: response.longitude
    end
  end

  def address_components query
    @component_cache ||= Hash.new
    @component_cache[query] ||= geocode_data["address_components"].select{|c| c['types'].include? query}
  end

  def address_component query
    address_components(query).first || {}
  end

  %w(country administrative_area_level_1 locality).each do |key|
    define_method key do
      address_component(key)["long_name"]
    end
  end

  alias_method :state, :administrative_area_level_1
  alias_method :city, :locality


  def formatted_address
    geocode_data["formatted_address"]
  end
  alias_method :address, :formatted_address
end
