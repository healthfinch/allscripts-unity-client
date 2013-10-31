require 'logger'

module AllscriptsUnityClient
  class ClientDriver
    LOG_FILE = "logs/unity_client.log"

    attr_accessor :username, :password, :appname, :base_unity_url, :proxy, :security_token, :timezone, :logger, :log

    def initialize(base_unity_url, username, password, appname, proxy = nil, timezone = nil, logger = nil, log = true)
      raise ArgumentError, "base_unity_url can not be nil" if base_unity_url.nil?
      raise ArgumentError, "username can not be nil" if username.nil?
      raise ArgumentError, "password can not be nil" if password.nil?
      raise ArgumentError, "appname can not be nil" if appname.nil?

      @base_unity_url = base_unity_url.gsub /\/$/, ""
      @username = username
      @password = password
      @appname = appname
      @proxy = proxy
      @log = log

      if logger.nil?
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::INFO
      end

      unless timezone.nil?
        @timezone = Timezone.new(timezone)
      else
        @timezone = Timezone.new("UTC")
      end
    end

    def security_token?
      return !@security_token.nil?
    end

    def log?
      return @log
    end

    def client_type
      return :none
    end

    def magic(parameters = {})
      raise NotImplementedError, "magic not implemented"
    end

    def get_security_token!(parameters = {})
      raise NotImplementedError, "get_security_token! not implemented"
    end

    def retire_security_token!(parameters = {})
      raise NotImplementedError, "retire_security_token! not implemented"
    end

    protected

    def log_get_security_token
      message = "Unity API GetSecurityToken request to #{@base_unity_url}"
      log_info(message)
    end

    def log_retire_security_token
      message = "Unity API RetireSecurityToken request to #{@base_unity_url}"
      log_info(message)
    end

    def log_magic(request)
      raise ArgumentError, "request can not be nil" if request.nil?
      message = "Unity API Magic request to #{@base_unity_url} [#{request.parameters[:action]}]"
      log_info(message)
    end

    def log_info(message)
      if log? && !logger.nil? && !message.nil?
        message += " #{@timer} seconds" unless @timer.nil?
        @timer = nil
        logger.info(message)
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