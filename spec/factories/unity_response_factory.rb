FactoryGirl.define do
  factory :unity_response, class: AllscriptsUnityClient::UnityResponse do
    initialize_with { new(response, timezone) }

    response {}
    timezone { build(:timezone) }
  end
end