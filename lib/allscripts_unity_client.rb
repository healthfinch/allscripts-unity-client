require "allscripts_unity_client/utilities"
require "allscripts_unity_client/timezone"
require "allscripts_unity_client/unity_request"
require "allscripts_unity_client/json_unity_request"
require "allscripts_unity_client/unity_response"
require "allscripts_unity_client/json_unity_response"
require "allscripts_unity_client/client"
require "allscripts_unity_client/client_driver"
require "allscripts_unity_client/soap_client_driver"
require "allscripts_unity_client/json_client_driver"

module AllscriptsUnityClient
  class APIError < RuntimeError
  end

  def self.create(parameters = {})
    parameters[:mode] ||= :soap
    raise_if_parameters_invalid parameters

    case parameters[:mode]
    when :json
      client_driver = JSONClientDriver.new(parameters[:base_unity_url], parameters[:username], parameters[:password], parameters[:appname], parameters[:proxy], parameters[:timezone])
    when :soap
      client_driver = SOAPClientDriver.new(parameters[:base_unity_url], parameters[:username], parameters[:password], parameters[:appname], parameters[:proxy], parameters[:timezone])
    end

    client = Client.new(client_driver)
    client.get_security_token!
    client
  end

  private

  def self.raise_if_parameters_invalid(parameters)
    raise ArgumentError, ":mode must be :json or :soap" if ![:json, :soap].include?(parameters[:mode])
    raise ArgumentError, ":base_unity_url required" if parameters[:base_unity_url].nil?
    raise ArgumentError, ":username required" if parameters[:username].nil?
    raise ArgumentError, ":password required" if parameters[:password].nil?
    raise ArgumentError, ":appname required" if parameters[:appname].nil?
  end
end

