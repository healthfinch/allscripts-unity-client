FactoryGirl.define do
  factory :unity_request, class: AllscriptsUnityClient::UnityRequest do
    initialize_with { new(parameters, timezone, appname, security_token) }

    parameters { build(:magic_request) }
    timezone { build(:timezone) }
    appname Faker::Name.name
    security_token SecureRandom.uuid
  end
end