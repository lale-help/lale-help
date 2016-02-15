class Location < ActiveRecord::Base
  has_many :circles
  has_many :users
  has_many :task_assignments, class_name: "Task::LocationAssignment"
  has_many :tasks, through: :task_assignments

  geocoded_by :geocode_query
  reverse_geocoded_by :latitude, :longitude

  def self.location_from(location_text)
    return unless location_text.present?
    previous_locaion = Location.find_by('lower(geocode_query) = ?', location_text.downcase)
    if previous_locaion.present?
      Rails.logger.debug "[Location] cache hit"
      return previous_locaion
    end

    Rails.logger.debug "[Location] cache miss"
    response = Geocoder.search(location_text).first

    if response.present?
      location = Location.create geocode_query: location_text, geocode_data: response.data, latitude: response.latitude, longitude: response.longitude
      location.update_timezone
      location
    else
      Location.create geocode_query: location_text
    end
  end

  def update_timezone
    self.timezone = Timezone::Zone.new(:latlon => [self.latitude, self.longitude]).zone
    save
  end

  def address_components query
    @component_cache ||= Hash.new
    @component_cache[query] ||= geocode_data["address_components"].select{|c| c['types'].include? query}
  end

  def geocode_data?
    geocode_data.present?
  end

  def address_component query
    address_components(query).first || {}
  end

  %w(country administrative_area_level_1 locality).each do |key|
    define_method key do
      address_component(key)["long_name"] if geocode_data?
    end
  end

  alias_method :state, :administrative_area_level_1
  alias_method :city, :locality


  def formatted_address
    if geocode_data?
      geocode_data["formatted_address"]
    else
      geocode_query
    end
  end
  alias_method :address, :formatted_address

  def display_name
    self.address
  end
end
