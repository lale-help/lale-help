class Address < ActiveRecord::Base
  has_many :users
  belongs_to :location

  def location_query
    [city, state_province, country].compact!.delete_if{ |s| s.empty? }.join(', ')
  end

end
