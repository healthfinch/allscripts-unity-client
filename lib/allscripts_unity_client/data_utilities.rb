module AllscriptsUnityClient
  class DataUtilities
    DATETIME_REGEX = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2}))(T| )\d{1,2}:\d{2}(:\d{2})?(\.\d+)?( ?PM|AM|pm|am)?((-|\+)\d{2}:?\d{2})?Z?$/
    DATE_REGEX = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2}))$/

    def self.encode_date(possible_date)
      if possible_date.nil?
        return nil
      end

      if possible_date.is_a?(String) && possible_date =~ DATE_REGEX
        return Date.parse(possible_date)
      end

      if possible_date.is_a?(String) && possible_date =~ DATETIME_REGEX
        return DateTime.parse(possible_date)
      end

      possible_date
    end

    def self.encode_data(data)
      if data.nil?
        return nil
      end

      if data.respond_to?(:bytes)
        return data.bytes.pack("m")
      elsif data.is_a?(Array)
        return data.pack("m")
      end
    end
  end
end