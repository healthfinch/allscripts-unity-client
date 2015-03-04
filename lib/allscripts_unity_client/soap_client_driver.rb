require 'savon'

module AllscriptsUnityClient

  # A ClientDriver that supports Unity's SOAP endpoints.
  class SOAPClientDriver < ClientDriver
    attr_accessor :savon_client

    UNITY_EHR_SOAP_ENDPOINT = '/Unity/UnityService.svc/unityservice'
    UNITY_PM_SOAP_ENDPOINT = '/UnityPM/UnityService.svc/unityservice'
    
    UNITY_ENDPOINT_NAMESPACE = 'http://www.allscripts.com/Unity/IUnityService'

    # Constructor.
    #
    # options:: See ClientOptions.
    def initialize(options)
      super
      @soap_endpoint = case @options.product
        when :ehr then UNITY_EHR_SOAP_ENDPOINT
        when :pm then UNITY_PM_JSON_ENDPOINT
        else raise ArgumentError, 'product not recognized'
      end

      client_proxy = @options.proxy
      base_unity_url = "#{@options.base_unity_url}#{@soap_endpoint}"

      @savon_client = Savon.client do
        # Removes the wsdl: namespace from body elements in the SOAP
        # request. Unity doesn't recognize elements otherwise.
        namespace_identifier nil

        # Manually registers SOAP endpoint since Unity WSDL is not very
        # good.
        endpoint base_unity_url

        # Manually register SOAP namespace. This URL isn't live, but the
        # internal SOAP endpoints expect it.
        namespace 'http://www.allscripts.com/Unity'

        # Register proxy with Savon if one was given.
        unless client_proxy.nil?
          proxy client_proxy
        end

        # Unity expects the SOAP envelop to be namespaced with soap:
        env_namespace :soap

        # Unity uses Microsoft style CamelCase for keys. Only really useful when using
        # symbol keyed hashes.
        convert_request_keys_to :camelcase

        # Enable gzip on HTTP responses. Unity does not currently support this
        # as of Born On 10/7/2013, but it doesn't hurt to future-proof. If gzip
        # is ever enabled, this library will get a speed bump for free.
        headers({ 'Accept-Encoding' => 'gzip,deflate'})

        # Disable Savon logs
        log false
      end
    end

    # Returns :soap.
    def client_type
      :soap
    end

    # See Client#magic.
    def magic(parameters = {})
      request_data = UnityRequest.new(parameters, @options.timezone, @options.appname, @security_token)
      call_data = {
        message: request_data.to_hash,
        soap_action: "#{UNITY_ENDPOINT_NAMESPACE}/Magic"
      }

      response = nil
      begin
        start_timer
        NewRelicSupport.trace_execution_scoped_if_available(self.class, ["Custom/UnitySOAP/#{parameters[:action]}"]) do
          response = @savon_client.call('Magic', call_data)
          end_timer
        end
      rescue Savon::SOAPFault => e
        raise APIError, e.message
      end

      log_magic(request_data)

      response = UnityResponse.new(response.body, @options.timezone)
      response.to_hash
    end

    # See Client#get_security_token!.
    def get_security_token!(parameters = {})
      username = parameters[:username] || @options.username
      password = parameters[:password] || @options.password
      appname = parameters[:appname] || @options.appname

      call_data = {
        message: {
          'Username' => username,
          'Password' => password,
          'Appname' => appname
        },
        soap_action: "#{UNITY_ENDPOINT_NAMESPACE}/GetSecurityToken"
      }

      begin
        start_timer
        response = nil
        NewRelicSupport.trace_execution_scoped_if_available(self.class, ["Custom/UnitySOAP/GetToken"]) do
          response = @savon_client.call('GetSecurityToken', call_data)
          end_timer
        end
      rescue Savon::SOAPFault => e
        raise APIError, e.message
      end

      log_get_security_token

      @security_token = response.body[:get_security_token_response][:get_security_token_result]
    end

    # See Client#retire_security_token!.
    def retire_security_token!(parameters = {})
      token = parameters[:token] || @security_token
      appname = parameters[:appname] || @options.appname

      call_data = {
        message: {
          'Token' => token,
          'Appname' => appname
        },
        soap_action: "#{UNITY_ENDPOINT_NAMESPACE}/RetireSecurityToken"
      }

      begin
        start_timer
        NewRelicSupport.trace_execution_scoped_if_available(self.class, ["Custom/UnitySOAP/RetireSecurityToken"]) do
          @savon_client.call('RetireSecurityToken', call_data)
          end_timer
        end
      rescue Savon::SOAPFault => e
        raise APIError, e.message
      end

      log_retire_security_token

      @security_token = nil
    end
  end
end