FactoryGirl.define do
  factory :unity_response, class: AllscriptsUnityClient::UnityResponse do
    initialize_with { new(response, timezone) }

    response Hash.new
    timezone { build(:timezone) }

    factory :json_unity_response, class: AllscriptsUnityClient::JSONUnityResponse
  end
end