FactoryBot.define do
  factory :unity_response, class: AllscriptsUnityClient::UnityResponse do
    initialize_with { new(response, timezone) }

    response Hash.new
    timezone ActiveSupport::TimeZone['Etc/UTC']

    factory :json_unity_response, class: AllscriptsUnityClient::JSONUnityResponse

    skip_create
  end
end
