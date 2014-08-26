require 'nori'
require 'date'
require 'american_date'

module AllscriptsUnityClient
  class Utilities
    DATETIME_REGEX = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})|(\d{1,2}-[A-Za-z]{3,4}-\d{4})|([A-Za-z]{3,4} +\d{1,2} \d{2,4}))(T| +)(\d{1,2}:\d{2}(:\d{2})?(\.\d+)? ?(PM|AM|pm|am)?((-|\+)\d{2}:?\d{2})?Z?)$/
    DATE_REGEX = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})|(\d{1,2}-[A-Za-z]{3,4}-\d{4})|([A-Za-z]{3,4} +\d{1,2} \d{2,4}))$/

    def self.try_to_encode_as_date(possible_date)
      if possible_date.nil?
        return nil
      end

      if possible_date.is_a?(String) && possible_date =~ DATE_REGEX
        # PM returns some date fields (DOB) as 'mm-dd-yyyy'
        return Date.parse(possible_date) rescue return Date.strptime(possible_date, '%m-%d-%Y') 
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

      if data.respond_to?(:pack)
        return data.pack('m')
      else
        return [data].pack('m')
      end
    end

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