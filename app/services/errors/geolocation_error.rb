module Errors
  class GeolocationError < StandardError
    attr_reader :code, :meta
    def initialize(message = 'Geolocation error', code: 'GEO_ERROR', meta: {})
      @code = code
      @meta = meta
      super(message)
    end
  end
end
