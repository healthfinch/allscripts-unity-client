module AllscriptsUnityClient
  class JSONClient < BaseClient
    attr_accessor :json_base_url
    UNITY_JSON_ENDPOINT = "/Unity/UnityService.svc/json"

    def setup!
      @json_base_url = "#{@base_unity_url}#{UNITY_JSON_ENDPOINT}"

      # Setup Nori the same way Savon does so we can parse XML in the same way.
      @nori_parser = Nori.new({ :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }, :strip_namespaces => true })
      get_security_token!
    end

    def magic(parameters = {})
      request_data = map_magic_request(parameters)
      request = create_httpi_request("#{@json_base_url}/Magic", request_data)
      response = HTTPI.post(request)

      raise_if_response_error(response)

      map_magic_response(@nori_parser.parse(response.body), parameters[:action])
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