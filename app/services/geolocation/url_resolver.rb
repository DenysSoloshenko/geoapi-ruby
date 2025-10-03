require 'resolv'
require 'uri'

module Geolocation
  class UrlResolver
    def self.resolve(input)
      s = input.to_s.strip
      return s if s =~ Resolv::IPv4::Regex || s =~ Resolv::IPv6::Regex

      uri = s
      uri = "http://#{uri}" unless uri.start_with?('http://', 'https://')
      host = URI.parse(uri).host
      raise ArgumentError, 'Invalid URL' if host.blank?

      Resolv.getaddress(host)
    rescue Resolv::ResolvError, URI::InvalidURIError
      raise ArgumentError, 'Unable to resolve host'
    end
  end
end
