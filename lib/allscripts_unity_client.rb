require "allscripts_unity_client/utilities"
require "allscripts_unity_client/timezone"
require "allscripts_unity_client/unity_request"
require "allscripts_unity_client/json_unity_request"
require "allscripts_unity_client/unity_response"
require "allscripts_unity_client/json_unity_response"
require "allscripts_unity_client/base_client"
require "allscripts_unity_client/soap_client"
require "allscripts_unity_client/json_client"

module AllscriptsUnityClient
  class APIError < RuntimeError
  end

  def self.create(parameters = {})
    mode = parameters[:mode] || :soap
    raise_if_required_parameters_missing parameters

    if mode == :json
      client = JSONClient.new(parameters[:base_unity_url], parameters[:username], parameters[:password], parameters[:appname], parameters[:proxy], parameters[:timezone])
    elsif mode == :soap
      client = SOAPClient.new(parameters[:base_unity_url], parameters[:username], parameters[:password], parameters[:appname], parameters[:proxy], parameters[:timezone])
    end

    client.get_security_token!
    client
  end

  private

  def self.raise_if_required_parameters_missing(parameters)
    raise ":base_unity_url required" unless parameters[:base_unity_url]
    raise ":username required" unless parameters[:username]
    raise ":password required" unless parameters[:password]
    raise ":appname required" unless parameters[:appname]
  end
end

