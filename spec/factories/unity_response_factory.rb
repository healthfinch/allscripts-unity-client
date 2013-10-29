FactoryGirl.define do
  factory :unity_response, :class => AllscriptsUnityClient::UnityResponse do
    initialize_with { new(response, timezone) }

    response FactoryGirl.build(:magic_response_soap)
    timezone FactoryGirl.build(:timezone)
  end
end