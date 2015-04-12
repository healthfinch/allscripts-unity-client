require 'oj'
require 'faraday'
require 'em-http-request'

module AllscriptsUnityClient

  # A ClientDriver that supports Unity's JSON endpoints.
  class JSONClientDriver < ClientDriver
    attr_accessor :json_base_url, :connection, :json_endpoint

    # NOTE: @options.base_unity_url need to be specified in the form of
    # http(s)://server-name/Unity/UnityService.svc
    # https://srt-unity-pro2.allscripts.com/unity_adppro13SSL/unityservice.svc

    # Constructor.
    #
    # options:: See ClientOptions.
    def initialize(options)
      super
      @json_endpoint = @options.base_unity_url + '/json'

      @connection = Faraday.new(build_faraday_options) do |conn|
        conn.adapter :em_http
      end
    end

    # Returns :json.
    def client_type
      :json
    end

    # See Client#magic.
    def magic(parameters = {})
      request_data = JSONUnityRequest.new(parameters, @options.timezone, @options.appname, @security_token)

      response = nil
      NewRelicSupport.trace_execution_scoped_if_available(self.class, ["Custom/UnityJSON/#{parameters[:action]}"]) do
        response = @connection.post do |request|
          request.url "#{@json_endpoint}/MagicJson"
          request.headers['Content-Type'] = 'application/json'
          request.body = Oj.dump(request_data.to_hash, mode: :compat)
          set_request_timeout(request)

          start_timer
        end
        end_timer
      end

      status = response.status
      
      response = Oj.load(response.body, mode: :strict)

      raise_if_response_error(response, status)
      log_magic(request_data)

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

      response = nil
      NewRelicSupport.trace_execution_scoped_if_available(self.class, ["Custom/UnityJSON/GetToken"]) do
        response = @connection.post do |request|
          request.url "#{@json_endpoint}/GetToken"
          request.headers['Content-Type'] = 'application/json'
          request.body = Oj.dump(request_data, mode: :compat)
          set_request_timeout(request)

          start_timer
        end
        end_timer
      end

      raise_if_response_error(response.body, response.status)
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

      response = nil
      NewRelicSupport.trace_execution_scoped_if_available(self.class, ["Custom/UnityJSON/RetireSecurityToken"]) do
        response = @connection.post do |request|
          request.url "#{@json_endpoint}/RetireSecurityToken"
          request.headers['Content-Type'] = 'application/json'
          request.body = Oj.dump(request_data, mode: :compat)
          set_request_timeout(request)

          start_timer
        end
        end_timer
      end

      raise_if_response_error(response.body, response.status)
      log_retire_security_token

      @security_token = nil
    end

    private

    def raise_if_response_error(response, status=nil)
      if status.present? && status != 200
        raise APIError, "Response status was #{status}"
      elsif response.blank?
        raise APIError, 'Response was empty'
      elsif response.is_a?(Array) && !response[0].nil? && !response[0]['Error'].nil?
        raise APIError, response[0]['Error']
      elsif response.is_a?(String) && response.match(/error/i)
        raise APIError, response
      end
    end

    def build_faraday_options
      options = {}

      # Configure root certificates for Faraday using options or via auto-detection
      if @options.ca_file?
        options[:ssl] = { ca_file: @options.ca_file }
      elsif @options.ca_path?
        options[:ssl] = { ca_path: @options.ca_path }
      elsif ca_file = JSONClientDriver.find_ca_file
        options[:ssl] = { ca_file: ca_file }
      elsif ca_path = JSONClientDriver.find_ca_path
        options[:ssl] = { ca_path: ca_path }
      end

      # Configure proxy
      if @options.proxy?
        options[:proxy] = @options.proxy
      end

      options
    end

    def self.find_ca_path
      if File.directory?('/usr/lib/ssl/certs')
        return '/usr/lib/ssl/certs'
      end

      nil
    end

    def self.find_ca_file
      if File.exists?('/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt')
        return '/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt'
      end

      if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
        return '/opt/local/share/curl/curl-ca-bundle.crt'
      end

      if File.exists?('/usr/lib/ssl/certs/ca-certificates.crt')
        return '/usr/lib/ssl/certs/ca-certificates.crt'
      end

      nil
    end

    def set_request_timeout(request)
      if @options.timeout?
        request.options[:timeout] = @options.timeout
        request.options[:open_timeout] = @options.timeout
      else
        request.options[:timeout] = 90
        request.options[:open_timeout] = 90
      end
    end
  end
end