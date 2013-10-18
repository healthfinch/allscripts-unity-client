module AllscriptsUnityClient
  class JSONUnityResponse < UnityResponse
    def to_hash
      result = JSON.parse(@response.body)

      # All JSON magic results are an array with one item
      result = result.first

      # All JSON magic results contain one key on their object named
      # actioninfo
      result = result.values.first

      if result.count == 1
        result = result.first
      end

      result = convert_dates_to_utc(result)
      recursively_symbolize_keys(result)
    end

    protected

    def recursively_symbolize_keys(hash)
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