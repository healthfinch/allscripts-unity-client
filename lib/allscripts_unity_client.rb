require 'active_support/time'
require 'allscripts_unity_client/utilities'
require 'allscripts_unity_client/unity_request'
require 'allscripts_unity_client/json_unity_request'
require 'allscripts_unity_client/unity_response'
require 'allscripts_unity_client/json_unity_response'
require 'allscripts_unity_client/client'
require 'allscripts_unity_client/client_driver'
require 'allscripts_unity_client/client_options'
require 'allscripts_unity_client/soap_client_driver'
require 'allscripts_unity_client/json_client_driver'
require 'allscripts_unity_client/new_relic_support'

# A library for consuming Allscripts Unity web services.
module AllscriptsUnityClient

  # Any error returned from Unity is thrown as this error type
  # with the error message.
  class APIError < RuntimeError
  end

  # Create an instance of the Unity client.
  #
  # options:: See ClientOptions.
  #
  # Returns an instance of Client.
  def self.create(options = {})
    options[:mode] ||= :soap
    options[:log] = true unless options[:log] === false
    raise_if_options_invalid options

    if options[:mode] == :json
      client_driver = JSONClientDriver.new(options)
    else
      client_driver = SOAPClientDriver.new(options)
    end

    Client.new(client_driver)
  end

  private

  def self.raise_if_options_invalid(options)
    raise ArgumentError, ':mode must be :json or :soap' unless [:json, :soap].include?(options[:mode])
  end
end