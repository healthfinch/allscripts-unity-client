require "json"
require "httpi"

module AllscriptsUnityClient
  class JSONClientDriver < ClientDriver
    attr_accessor :json_base_url

    UNITY_JSON_ENDPOINT = "/Unity/UnityService.svc/json"

    def initialize(base_unity_url, username, password, appname, proxy = nil, timezone = nil, logger = nil, log = true)
      super

      # Disable HTTPI logging
      HTTPI.log = false

      @json_base_url = "#{@base_unity_url}#{UNITY_JSON_ENDPOINT}"
    end

    def client_type
      return :json
    end

    def magic(parameters = {})
      request_data = JSONUnityRequest.new(parameters, @timezone, @appname, @security_token)
      request = create_httpi_request("#{@json_base_url}/MagicJson", request_data.to_hash)

      start_timer
      response = HTTPI.post(request)
      end_timer

      response = JSON.parse(response.body)

      raise_if_response_error(response)
      log_magic(request_data)

      response = JSONUnityResponse.new(response, @timezone)
      response.to_hash
    end

    def get_security_token!(parameters = {})
      username = parameters[:username] || @username
      password = parameters[:password] || @password
      appname = parameters[:appname] || @appname

      request_data = {
        "Username" => username,
        "Password" => password,
        "Appname" => appname
      }
      request = create_httpi_request("#{@json_base_url}/GetToken", request_data)

      start_timer
      response = HTTPI.post(request, :net_http_persistent)
      end_timer

      raise_if_response_error(response.body)
      log_get_security_token

      @security_token = response.body
    end

    def retire_security_token!(parameters = {})
      token = parameters[:token] || @security_token
      appname = parameters[:appname] || @appname

      request_data = {
        "Token" => token,
        "Appname" => appname
      }
      request = create_httpi_request("#{@json_base_url}/RetireSecurityToken", request_data)

      start_timer
      response = HTTPI.post(request, :net_http_persistent)
      end_timer

      raise_if_response_error(response.body)
      log_retire_security_token

      @security_token = nil
    end

    private

    def create_httpi_request(url, data)
      request = HTTPI::Request.new
      request.url = url
      request.headers = {
        "Accept-Encoding" => "gzip,deflate",
        "Content-type" => "application/json;charset=utf-8"
      }
      request.body = JSON.generate(data)

      unless @proxy.nil?
        request.proxy = @proxy
      end

      request
    end

    def raise_if_response_error(response)
      if response.nil?
        raise APIError, "Response was empty"
      elsif response.is_a?(Array) && !response[0]["Error"].nil?
        raise APIError, response[0]["Error"]
      elsif response.is_a?(String) && response.include?("error:")
        raise APIError, response
      end
    end
  end
end