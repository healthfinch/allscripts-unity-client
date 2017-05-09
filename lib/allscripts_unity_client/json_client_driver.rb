require 'multi_json'
require 'httpclient'

module AllscriptsUnityClient

  # A ClientDriver that supports Unity's JSON endpoints.
  class JSONClientDriver < ClientDriver
    attr_accessor :json_base_url, :connection

    UNITY_JSON_ENDPOINT = '/Unity/UnityService.svc/json'

    def initialize(options)
      super


      @connection = HTTPClient.new(
        proxy: @options.proxy,
        default_header: {'Content-Type' => 'application/json'}
      )

      set_http_client_ssl_config
      set_http_client_timeouts
    end

    def set_http_client_timeouts
      @connection.connect_timeout = @options.timeout || 90
      @connection.send_timeout = @options.timeout || 90
      @connection.receive_timeout = @options.timeout || 90
    end

    def set_http_client_ssl_config
      ssl_options = OpenSSL::SSL::OP_ALL
      ssl_options &= ~OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS if defined?(OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS)
      ssl_options |= OpenSSL::SSL::OP_NO_COMPRESSION if defined?(OpenSSL::SSL::OP_NO_COMPRESSION)
      ssl_options |= OpenSSL::SSL::OP_NO_SSLv2 if defined?(OpenSSL::SSL::OP_NO_SSLv2)
      ssl_options |= OpenSSL::SSL::OP_NO_SSLv3 if defined?(OpenSSL::SSL::OP_NO_SSLv3)

      @connection.ssl_config.options = ssl_options
      @connection.ssl_config.ciphers = "ALL:!aNULL:!eNULL:!SSLv2"
    end

    def build_uri(request_location)
      "#{@options.base_unity_url}#{[UNITY_JSON_ENDPOINT, request_location].join('/')}"
    end

    def client_type
      :json
    end

    def magic(parameters = {})
      request = JSONUnityRequest.new(parameters, @options.timezone, @options.appname, @security_token)
      request_hash = request.to_hash
      request_data = MultiJson.dump(request_hash)

      start_timer
      response = @connection.post(build_uri('MagicJson'), request_data)
      end_timer

      # NOTE: ClientDriver#log_magic uses ClientDriver#log_info, which
      # appends timing info (if end_timer has been called previously),
      # and then resets the timer.
      #
      # It would be nice if future work made this less stateful.
      log_magic(request)
      log_info("Response Status: #{response.status}")

      response = MultiJson.load(response.body)
      raise_if_response_error(response)

      response = JSONUnityResponse.new(response, @options.timezone)
      response.to_hash
    end

    # See Client#get_security_token!.
    def get_security_token!(parameters = {})
      username = parameters[:username] || @options.username
      password = parameters[:password] || @options.password
      appname = parameters[:appname] || @options.appname

      request_data = {
        'Username' => username,
        'Password' => password,
        'Appname' => appname
      }

      start_timer
      response = @connection.post(build_uri('GetToken'), MultiJson.dump(request_data.to_hash))
      end_timer

      raise_if_response_error(response.body)
      log_get_security_token

      @security_token = response.body
    end

    # See Client#retire_security_token!.
    def retire_security_token!(parameters = {})
      token = parameters[:token] || @security_token
      appname = parameters[:appname] || @options.appname

      request_data = {
        'Token' => token,
        'Appname' => appname
      }

      start_timer
      response = @connection.post(build_uri('RetireSecurityToken'), MultiJson.dump(request_data.to_hash))
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
