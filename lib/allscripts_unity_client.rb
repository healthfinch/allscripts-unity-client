require "nori"
require "json"
require "httpi"
require "date"
require "tzinfo"
require "savon"
require "nokogiri"
require "allscripts_unity_client/base_client"
require "allscripts_unity_client/soap_client"
require "allscripts_unity_client/json_client"

module AllscriptsUnityClient
  class APIError < RuntimeError
  end

  def self.create(parameters = {})
    mode = parameters[:mode] || :soap
    validate_parameters parameters

    if mode == :json
      JSONClient.new(parameters[:base_unity_url], parameters[:username], parameters[:password], parameters[:appname], parameters[:proxy], parameters[:timezone])
    elsif mode == :soap
      SOAPClient.new(parameters[:base_unity_url], parameters[:username], parameters[:password], parameters[:appname], parameters[:proxy], parameters[:timezone])
    end
  end

  private

  def self.validate_parameters(parameters)
    raise ":base_unity_url required" unless parameters[:base_unity_url]
    raise ":username required" unless parameters[:username]
    raise ":password required" unless parameters[:password]
    raise ":appname required" unless parameters[:appname]
  end
end

