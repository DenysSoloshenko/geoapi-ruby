class LocationSerializer
  include JSONAPI::Serializer
  set_type :location

  attributes :input, :ip, :hostname, :continent_code, :continent_name,
             :country_code, :country_name, :region_code, :region_name,
             :city, :zip, :latitude, :longitude, :created_at, :updated_at
end
