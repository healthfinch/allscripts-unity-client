module AllscriptsUnityClient
  class ClientOptions
    attr_accessor :proxy, :logger
    attr_reader :base_unity_url, :username, :password, :appname, :timezone

    def initialize(options = {})
      @base_unity_url = options[:base_unity_url] ? options[:base_unity_url].gsub(/\/$/, "") : nil
      @username = options[:username]
      @password = options[:password]
      @appname = options[:appname]
      @proxy = options[:proxy]
      self.timezone = options[:timezone]
      @logger = options[:logger]

      validate_options
    end

    def validate_options(options = {})
      base_unity_url = options.has_key?(:base_unity_url) ? options[:base_unity_url] : @base_unity_url
      username = options.has_key?(:username) ? options[:username] : @username
      password = options.has_key?(:password) ? options[:password] : @password
      appname = options.has_key?(:appname) ? options[:appname] : @appname

      raise ArgumentError, "base_unity_url can not be nil" if base_unity_url.nil?
      raise ArgumentError, "username can not be nil" if username.nil?
      raise ArgumentError, "password can not be nil" if password.nil?
      raise ArgumentError, "appname can not be nil" if appname.nil?
    end

    def base_unity_url=(base_unity_url)
      validate_options(base_unity_url: base_unity_url)
      @base_unity_url = base_unity_url.gsub /\/$/, ""
    end

    def username=(username)
      validate_options(username: username)
      @username = username
    end

    def password=(password)
      validate_options(password: password)
      @password = password
    end

    def appname=(appname)
      validate_options(appname: appname)
      @appname = appname
    end

    def timezone=(timezone)
      unless timezone.nil?
        @timezone = Timezone.new(timezone)
      else
        @timezone = Timezone.new("UTC")
      end
    end

    def proxy?
      !@proxy.nil?
    end

    def logger?
      !@logger.nil?
    end
  end
end