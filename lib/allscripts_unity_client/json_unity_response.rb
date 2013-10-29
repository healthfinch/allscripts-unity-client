require "json"

module AllscriptsUnityClient
  class JSONUnityResponse < UnityResponse
    def to_hash
      result = @response

      if result.empty?
        return []
      end

      # All JSON magic responses are an array with one item
      result = result.first

      # All JSON magic results contain one key on their object named
      # actioninfo
      result = result.values.first

      # The data in a JSON magic result is always an array. If that array
      # only has a single item, then just return that as the result. This is
      # a compromise as some actions that should always return arrays
      # (i.e. GetProviders) may return a single hash.
      if result.count == 1
        result = result.first
      end

      result = convert_dates_to_utc(result)
      Utilities::recursively_symbolize_keys(result)
    end
  end
end