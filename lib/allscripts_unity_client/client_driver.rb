require 'logger'

module AllscriptsUnityClient
  class ClientDriver
    LOG_FILE = 'logs/unity_client.log'

    attr_accessor :options, :security_token

    def initialize(options)
      @options = ClientOptions.new(options)

      # If New Relic support is enabled, setup method tracing
      if @options.new_relic
        NewRelicSupport.enable_method_tracer(self)

        class << self
          add_method_tracer :magic
        end
      end
    end

    def security_token?
      !@security_token.nil?
    end

    def client_type
      :none
    end

    def magic(parameters = {})
      raise NotImplementedError, 'magic not implemented'
    end

    def get_security_token!(parameters = {})
      raise NotImplementedError, 'get_security_token! not implemented'
    end

    def retire_security_token!(parameters = {})
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
  end
end