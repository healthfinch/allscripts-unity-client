require 'json'
require 'faraday'
require 'em-http-request'

module AllscriptsUnityClient
  class JSONClientDriver < ClientDriver
    attr_accessor :json_base_url, :connection

    UNITY_JSON_ENDPOINT = '/Unity/UnityService.svc/json'

    def initialize(options)
      super
      @connection = Faraday.new(url: @options.base_unity_url) do |conn|
        if @options.proxy?
          conn.proxy @options.proxy
        end

        conn.adapter :em_http
      end
    end

    def client_type
      :json
    end

    def magic(parameters = {})
      request_data = JSONUnityRequest.new(parameters, @options.timezone, @options.appname, @security_token)

      response = @connection.post do |request|
        request.url "#{UNITY_JSON_ENDPOINT}/MagicJson"
        request.headers['Content-Type'] = 'application/json'
        request.body = JSON.generate(request_data.to_hash)
        start_timer
      end
      end_timer

      response = JSON.parse(response.body)

      raise_if_response_error(response)
      log_magic(request_data)

      response = JSONUnityResponse.new(response, @options.timezone)
      response.to_hash
    end

    def get_security_token!(parameters = {})
      username = parameters[:username] || @options.username
      password = parameters[:password] || @options.password
      appname = parameters[:appname] || @options.appname

      request_data = {
        'Username' => username,
        'Password' => password,
        'Appname' => appname
      }

      response = @connection.post do |request|
        request.url "#{UNITY_JSON_ENDPOINT}/GetToken"
        request.headers['Content-Type'] = 'application/json'
        request.body = JSON.generate(request_data)
        start_timer
      end
      end_timer

      raise_if_response_error(response.body)
      log_get_security_token

      @security_token = response.body
    end

    def retire_security_token!(parameters = {})
      token = parameters[:token] || @security_token
      appname = parameters[:appname] || @options.appname

      request_data = {
        'Token' => token,
        'Appname' => appname
      }

      response = @connection.post do |request|
        request.url "#{UNITY_JSON_ENDPOINT}/RetireSecurityToken"
        request.headers['Content-Type'] = 'application/json'
        request.body = JSON.generate(request_data)
        start_timer
      end
      end_timer

      raise_if_response_error(response.body)
      log_retire_security_token

      @security_token = nil
    end

    private

    def raise_if_response_error(response)
      if response.nil?
        raise APIError, 'Response was empty'
      elsif response.is_a?(Array) && !response[0].nil? && !response[0]['Error'].nil?
        raise APIError, response[0]['Error']
      elsif response.is_a?(String) && response.include?('error:')
        raise APIError, response
      end
    end
  end
end