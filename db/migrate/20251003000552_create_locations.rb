class CreateLocations < ActiveRecord::Migration[7.2]
  def change
    create_table :locations do |t|
      t.string :input
      t.string :ip
      t.string :hostname
      t.string :continent_code
      t.string :continent_name
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.string :key

      t.timestamps
    end
    add_index :locations, :key
  end
end
