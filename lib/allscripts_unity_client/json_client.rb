module AllscriptsUnityClient
  class JSONClient < BaseClient
    attr_accessor :json_base_url
    UNITY_JSON_ENDPOINT = "/Unity/UnityService.svc/json"

    def setup!
      @json_base_url = "#{@base_unity_url}#{UNITY_JSON_ENDPOINT}"
      get_security_token!
    end

    def magic(parameters = {})
      request_data = JSONUnityRequest.new(parameters, @timezone, @appname, @security_token)
      request = create_httpi_request("#{@json_base_url}/MagicJson", request_data.to_hash)
      response = HTTPI.post(request)

      raise_if_response_error(response)

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
      response = HTTPI.post(request, :net_http_persistent)

      raise_if_response_error(response)

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
      response = HTTPI.post(request, :net_http_persistent)

      raise_if_response_error(response)

      @security_token = nil
    end

    private

    def create_httpi_request(url, data)
      request = HTTPI::Request.new
      request.url = url
      request.headers = {
        "Accept-Encoding" => "gzip, deflate",
        "Content-type" => "application/json;charset=utf-8"
      }
      request.body = JSON.generate(data)

      unless @proxy.nil?
        request.proxy = @proxy
      end

      request
    end

    def raise_if_response_error(response)
      if response.code == 500 || response.code == 400
        error_text = Nokogiri::HTML(response.body).css("p.intro").first.text
        raise APIError, error_text
      end
    end
  end
end