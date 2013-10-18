module AllscriptsUnityClient
  class UnityResponse
    def initialize(response, timezone)
      raise ArgumentError, "timezone can not be nil" if timezone.nil?
      raise ArgumentError, "response can not be nil" if response.nil?

      @response = response
      @timezone = timezone
    end

    def to_hash
      result = @response[:magic_response][:magic_result][:diffgram]
      strip_attributes(result)
      convert_dates_to_utc(result)

      # All magic responses wrap their result in an ActionResponse element
      result = result.values.first

      if result.nil?
        return {}
      end

      # Often the first element in ActionResponse is an element
      # called ActionInfo, but in some cases it has a different name
      # so we just get the first element.
      result.values.first
    end

    private

    def strip_attributes(response)
      # Base case: nil maps to nil
      if response.nil?
        return nil
      end

      # Recurse step: if the value is a hash then delete all
      # keys that match the attribute pattern that Nori uses
      if response.is_a?(Hash)
        response.delete_if do |key, value|
          is_attribute = key.to_s =~ /^@/

          unless is_attribute
            strip_attributes(value)
          end

          is_attribute
        end

        return response
      end

      # Recurse step: if the value is an array then delete all
      # keys within hashes that match the attribute pattern that
      # Nori uses
      if response.is_a?(Array)
        result = response.map do |value|
          strip_attributes(value)
        end

        return result
      end

      # Base case: value doesn't need attributes stripped
      response
    end

    def convert_dates_to_utc(response)
      # Base case
      if response.nil?
        return nil
      end

      # Recurse step: if the value is an array then convert all
      # Ruby date objects to UTC
      if response.is_a?(Array)
        return response.map do |value|
          convert_dates_to_utc(value)
        end
      end

      # Recurse step: if the value is a hash then convert all
      # Ruby date object values to UTC
      if response.is_a?(Hash)
        result = response.map do |key, value|
          { key => convert_dates_to_utc(value) }
        end

        # Trick to make Hash#map return a hash. Simply calls the merge method
        # on each hash in the array to reduce to a single merged hash.
        return result.reduce(:merge)
      end

      # Base case: convert date object to UTC
      if response.instance_of?(Time) || response.instance_of?(DateTime) || response.instance_of?(Date)
        return @timezone.local_to_utc(response)
      end

      # Base case: value is not a date
      response
    end
  end
end