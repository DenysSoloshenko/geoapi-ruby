module Geolocation
  class Provider
    Result = Struct.new(
      :ip, :hostname, :continent_code, :continent_name,
      :country_code, :country_name, :region_code, :region_name,
      :city, :zip, :latitude, :longitude, keyword_init: true
    )

    def resolve(_input)
      raise NotImplementedError
    end
  end
end
