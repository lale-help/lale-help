class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.integer :circle_id
      t.integer :sponsor_id
      
      t.date :starts_on
      t.date :ends_on

      t.index :circle_id
      t.index :sponsor_id
      t.timestamps null: false
    end
  end
end
