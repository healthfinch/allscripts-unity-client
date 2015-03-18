require 'active_support/time'
require 'allscripts_unity_client/utilities'
require 'allscripts_unity_client/unity_request'
require 'allscripts_unity_client/json_unity_request'
require 'allscripts_unity_client/unity_response'
require 'allscripts_unity_client/json_unity_response'
require 'allscripts_unity_client/client'
require 'allscripts_unity_client/client_driver'
require 'allscripts_unity_client/client_options'
require 'allscripts_unity_client/json_client_driver'

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
    options[:mode] ||= :json
    if options[:log] != false # explictly
      options[:log] = true
    end

    if options[:mode] == :json
      client_driver = JSONClientDriver.new(options)
    else
      raise ArgumentError, ':mode must be :json' unless options[:mode] == :json
    end

    Client.new(client_driver)
  end
end
