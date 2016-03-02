class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :state_province
      t.string :postal_code
      t.string :country
      t.integer :location_id, null: true
      t.timestamps null: false
    end
    add_column :users, :address_id, :integer
    add_index :users, :address_id
    add_index :addresses, :location_id

    reversible do |change|
      change.up do
        User.all.each do |user|
          if user.address.nil?
            user.create_address(city: user.location.try(:geocode_query), location_id: user.location_id)
            user.save
          end
        end
      end
    end
  end
end
