class Circle < ActiveRecord::Base
  belongs_to :location
  belongs_to :address, autosave: true
end

class AddAddressesToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :address_id, :integer
  end

  def data
    Circle.find_each do |circle|
      location = circle.location
      address = circle.build_address

      if location.present?
        address.assign_attributes({
          city:            circle.location.city,
          state_province:  circle.location.state,
          country:         circle.location.country
        })
      end

      circle.save!

      puts circle.name
      puts "location[#{location.id}]: #{location.address}"    if location.present?
      puts "address[#{address.id}]:  #{address.full_address}" if address.present?
      puts
    end
  end
end
