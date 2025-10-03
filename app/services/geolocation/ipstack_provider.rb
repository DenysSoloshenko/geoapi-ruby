require 'faraday'
require_relative 'provider'
require_relative '../errors/geolocation_error'
require_relative 'url_resolver'

module Geolocation
  class IpstackProvider < Provider
    ENDPOINT = 'http://api.ipstack.com'.freeze

    def initialize(api_key: ENV['IPSTACK_API_KEY'], http: nil)
      @api_key = api_key
      raise Errors::GeolocationError.new('Missing ipstack API key', code: 'CONFIG') if @api_key.blank?

      @http = http || Faraday.new(url: ENDPOINT) do |f|
        f.request :url_encoded
        f.response :json, content_type: /\bjson$/
        f.adapter Faraday.default_adapter
        f.options.timeout = 5
        f.options.open_timeout = 2
      end
    end

    def resolve(input)
      ip = Geolocation::UrlResolver.resolve(input)

      resp = @http.get("/#{ip}", access_key: @api_key, hostname: 1)
      raise Errors::GeolocationError.new("ipstack HTTP #{resp.status}", code: 'HTTP') if resp.status != 200

      body = resp.body || {}
      if body.is_a?(Hash) && body['success'] == false && body['error']
        raise Errors::GeolocationError.new("ipstack: #{body['error']['info']}", code: 'PROVIDER', meta: body['error'])
      end

      country_code = body['country_code']
      raise Errors::GeolocationError.new('Empty geolocation result', code: 'EMPTY') if country_code.blank?

      Provider::Result.new(
        ip: body['ip'],
        hostname: body['hostname'],
        continent_code: body['continent_code'],
        continent_name: body['continent_name'],
        country_code: country_code,
        country_name: body['country_name'],
        region_code: body['region_code'],
        region_name: body['region_name'],
        city: body['city'],
        zip: body['zip'],
        latitude: body['latitude'],
        longitude: body['longitude']
      )
    rescue ArgumentError => e
      raise Errors::GeolocationError.new(e.message, code: 'INPUT')
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
      raise Errors::GeolocationError.new("ipstack connectivity: #{e.class}", code: 'NETWORK')
    end
  end
end
