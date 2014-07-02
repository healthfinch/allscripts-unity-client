module AllscriptsUnityClient
  class ClientOptions
    attr_accessor :proxy, :logger, :ca_file, :ca_path, :timeout, :new_relic
    attr_reader :base_unity_url, :username, :password, :appname, :timezone

    def initialize(options = {})
      @username = options[:username]
      @password = options[:password]
      @appname = options[:appname]
      @proxy = options[:proxy]
      @logger = options[:logger]
      @ca_file = options[:ca_file]
      @ca_path = options[:ca_path]
      @timeout = options[:timeout]
      @new_relic = options[:new_relic]

      self.timezone = options[:timezone]
      self.base_unity_url = options[:base_unity_url]

      validate_options
    end

    def validate_options(options = {})
      base_unity_url = options.has_key?(:base_unity_url) ? options[:base_unity_url] : @base_unity_url
      username = options.has_key?(:username) ? options[:username] : @username
      password = options.has_key?(:password) ? options[:password] : @password
      appname = options.has_key?(:appname) ? options[:appname] : @appname

      raise ArgumentError, 'base_unity_url can not be nil' if base_unity_url.nil?
      raise ArgumentError, 'username can not be nil' if username.nil?
      raise ArgumentError, 'password can not be nil' if password.nil?
      raise ArgumentError, 'appname can not be nil' if appname.nil?
    end

    def base_unity_url=(base_unity_url)
      validate_options(base_unity_url: base_unity_url)
      @base_unity_url = base_unity_url.gsub /\/$/, ''
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
      if !timezone.nil?
        @timezone = Timezone.new(timezone)
      else
        @timezone = Timezone.new('UTC')
      end
    end

    def proxy?
      !@proxy.to_s.strip.empty?
    end

    def logger?
      !@logger.nil?
    end

    def ca_file?
      !@ca_file.to_s.strip.empty?
    end

    def ca_path?
      !@ca_path.to_s.strip.empty?
    end

    def timeout?
      !@timeout.to_s.strip.empty?
    end

    def new_relic?
      !@new_relic.nil?
    end
  end
end