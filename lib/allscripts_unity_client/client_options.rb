module AllscriptsUnityClient

  # Contains various options for Unity configuration.
  class ClientOptions
    attr_accessor :proxy, :logger, :ca_file, :ca_path, :timeout, :ehr_userid, :ehr_password
    attr_reader :base_unity_url, :username, :password, :appname, :timezone, :raw_dates, :is_ubiquity_url

    # Constructor.
    #
    # options::
    #
    #   - :username - Unity license username for security token __(required)__.
    #   - :password - Unity license password for security token __(required)__.
    #   - :appname - Unity license appname __(required)__.
    #   - :proxy - A string URL pointing to an HTTP proxy (optional, primarily for debugging)
    #   - :logger - A Ruby object that adheres to the same interface as Logger.
    #   - :ca_file - A string path for a CA File on the OS (JSON only).
    #   - :cs_path - A string path for a CA directory (JSON only).
    #   - :timeout - The number of seconds to set the HTTP response timeout and keepalive timeout (JSON only).
    #   - :base_unity_url - The URL where a Unity server is located (i.e. https://unity.server.com) __(required)__
    #   - :ehr_userid - Allscripts EHR Username for user authentication __(required)__.
    #   - :ehr_password - EHR Password for user authentication __(required)__.
    #   - :is_ubiquity_url - Specifies whether the base_unity_url is a ubiquity endpoint
    def initialize(options = {})
      @username = options[:username]
      @password = options[:password]
      @appname = options[:appname]
      @proxy = options[:proxy]
      @logger = options[:logger]
      @ca_file = options[:ca_file]
      @ca_path = options[:ca_path]
      @timeout = options[:timeout]
      @ehr_userid = options[:ehr_userid]
      @ehr_password = options[:ehr_password]

      self.timezone = options[:timezone]
      self.base_unity_url = options[:base_unity_url]
      self.raw_dates = options[:raw_dates]

      validate_options
    end

    # Validates options by ensuring that all required options are present.
    #
    # See #initialize.
    def validate_options(options = {})
      base_unity_url = options.fetch(:base_unity_url, @base_unity_url)
      username = options.fetch(:username, @username)
      password = options.fetch(:password, @password)
      appname = options.fetch(:appname, @appname)

      raise ArgumentError, 'base_unity_url can not be nil' if base_unity_url.nil?
      raise ArgumentError, 'username can not be nil' if username.nil?
      raise ArgumentError, 'password can not be nil' if password.nil?
      raise ArgumentError, 'appname can not be nil' if appname.nil?
    end

    # Mutator for @base_unity_url.
    #
    # Strips trailing slash for URL.
    def base_unity_url=(base_unity_url)
      validate_options(base_unity_url: base_unity_url)
      @base_unity_url = base_unity_url.gsub(/\/$/, '')
    end

    # Mutator for @is_ubiquity_url.
    #
    # defaults value to false if nil
    def is_ubiquity_url=(is_ubiquity_url)
      @is_ubiquity_url = is_ubiquity_url || false
    end

    # Mutator for username.
    #
    # Ensures username is not nil,
    def username=(username)
      validate_options(username: username)
      @username = username
    end

    # Mutator for password.
    #
    # Ensures password is not nil,
    def password=(password)
      validate_options(password: password)
      @password = password
    end

    # Mutator for appname.
    #
    # Ensures appname is not nil,
    def appname=(appname)
      validate_options(appname: appname)
      @appname = appname
    end

    # Mutator for timezone.
    #
    # Ensures timezone is not nil,
    def timezone=(timezone)
      if !timezone.nil?
        @timezone = ActiveSupport::TimeZone[timezone]
      else
        @timezone = ActiveSupport::TimeZone['Etc/UTC']
      end
    end

    def raw_dates=(raw_dates)
      @raw_dates = raw_dates || false
    end

    # Return true if proxy is set and not empty.
    def proxy?
      !@proxy.to_s.strip.empty?
    end

    # Return true if logger is not nil.
    def logger?
      !@logger.nil?
    end

    # Return true if ca_file is not empty.
    def ca_file?
      !@ca_file.to_s.strip.empty?
    end

    # Return true if ca_path is not empty.
    def ca_path?
      !@ca_path.to_s.strip.empty?
    end

    # Return true if timeout is not empty.
    def timeout?
      !@timeout.to_s.strip.empty?
    end
  end
end
