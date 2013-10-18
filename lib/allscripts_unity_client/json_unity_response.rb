module AllscriptsUnityClient
  class JSONUnityResponse < UnityResponse
    def initialize(response, timezone)
      super
      @nori_parser = Nori.new({ :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }, :strip_namespaces => true })
    end

    def to_hash
      @response = @nori_parser.parse(@response.body)
      super
    end
  end
end