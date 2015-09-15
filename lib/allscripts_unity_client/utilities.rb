require 'nori'
require 'date'
require 'american_date'

module AllscriptsUnityClient

  # Utilities for massaging the data that comes back from Unity.
  class Utilities
    DATETIME_REGEX = /\A((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})|(\d{1,2}-[A-Za-z]{3,4}-\d{4})|([A-Za-z]{3,4} +\d{1,2} \d{2,4}))(T| +)(\d{1,2}:\d{2}(:\d{2})?(\.\d+)? ?(PM|AM|pm|am)?((-|\+)\d{2}:?\d{2})?Z?)\z/
    DATE_REGEX = /\A((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})|(\d{1,2}-[A-Za-z]{3,4}-\d{4})|([A-Za-z]{3,4} +\d{1,2} \d{2,4}))\z/

    # Try to encode a string into a Date or ActiveSupport::TimeWithZone object.
    #
    # Uses DATETIME_REGEX and DATE_REGEX to match possible date string.
    #
    # timezone:: An ActiveSupport::TimeZone instance.
    # possible_data:: A string that could contain a date.
    #
    # Returns Date or ActiveSupport::TimeWithZone, or the string if it did not contain a date.
    def self.try_to_encode_as_date(timezone, possible_date)
      if possible_date.nil?
        return nil
      end

      if possible_date.is_a?(String) && possible_date =~ DATE_REGEX
        return Date.parse(possible_date)
      end

      if possible_date.is_a?(String) && possible_date =~ DATETIME_REGEX
        return timezone.parse(possible_date)
      end

      possible_date
    end

    # Encode binary data into Base64 encoding.
    #
    # data:: Data to encode.
    #
    # The Base64 encoding of the data.
    def self.encode_data(data)
      if data.nil?
        return nil
      end

      if data.respond_to?(:pack)
        return data.pack('m')
      else
        return [data].pack('m')
      end
    end

    # Transform string keys into symbols and convert CamelCase to snake_case.
    #
    # hash:: The hash to transform.
    #
    # Returns the transformed hash.
    def self.recursively_symbolize_keys(hash)
      # Base case: nil maps to nil
      if hash.nil?
        return nil
      end

      # Recurse case: value is a hash so symbolize keys
      if hash.is_a?(Hash)
        result = hash.map do |key, value|
          { key.snakecase.to_sym => recursively_symbolize_keys(value) }
        end

        return result.reduce(:merge)
      end

      # Recurse case: value is an array so symbolize keys for any hash
      # in it
      if hash.is_a?(Array)
        result = hash.map do |value|
          recursively_symbolize_keys(value)
        end

        return result
      end

      # Base case: value was not an array or a hash, so just
      # return it
      hash
    end
  end
end
