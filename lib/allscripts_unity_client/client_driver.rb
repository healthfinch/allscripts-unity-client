require 'logger'

module AllscriptsUnityClient

  # An abstract class for ClientDrivers that fully implement
  # making calls to a Unity server.
  class ClientDriver
    LOG_FILE = 'logs/unity_client.log'

    attr_accessor :options, :security_token

    # Constructor.
    #
    # options:: See ClientOptions.
    def initialize(options)
      @options = ClientOptions.new(options)
    end

    # Returns true if security token is not nil.
    def security_token?
      !@security_token.nil?
    end

    # Returns the type of client, usually a symbol.
    def client_type
      :none
    end

    # See Client#magic.
    def magic(_parameters = {})
      raise NotImplementedError, 'magic not implemented'
    end

    # See Client#get_security_token!.
    def get_security_token!(_parameters = {})
      raise NotImplementedError, 'get_security_token! not implemented'
    end

    # See Client#retire_security_token!.
    def retire_security_token!(_parameters = {})
      raise NotImplementedError, 'retire_security_token! not implemented'
    end

    protected

    def log_get_security_token
      message = "Unity API GetSecurityToken request to #{@options.base_unity_url}"
      log_info(message)
    end

    def log_retire_security_token
      message = "Unity API RetireSecurityToken request to #{@options.base_unity_url}"
      log_info(message)
    end

    def log_magic(request)
      raise ArgumentError, 'request can not be nil' if request.nil?
      message = "Unity API Magic request to #{@options.base_unity_url} [#{request.parameters[:action]}]"
      log_info(message)
    end

    def log_info(message)
      if @options.logger? && !message.nil?
        message += " #{@timer} seconds" unless @timer.nil?
        @timer = nil
        @options.logger.info(message)
      end
    end

    def start_timer
      @start_time = Time.now.utc
    end

    def end_timer
      @end_time = Time.now.utc
      @timer = @end_time - @start_time
    end

    # Initializes a `GetSecurityTokenError` with a default message.
    #
    # @return [GetSecurityTokenError]
    def make_get_security_token_error
      base_unity_url = self.options.base_unity_url.inspect
      error_message = "Could not retrieve security token from #{base_unity_url}"

      GetSecurityTokenError.new(error_message)
    end
  end
end
