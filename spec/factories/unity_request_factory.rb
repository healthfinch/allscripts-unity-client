FactoryGirl.define do
  factory :unity_request, class: AllscriptsUnityClient::UnityRequest do
    initialize_with { new(parameters, timezone, appname, security_token) }

    parameters { build(:magic_request) }
    timezone ActiveSupport::TimeZone['Etc/UTC']
    appname Faker::Name.name
    security_token SecureRandom.uuid
    factory :json_unity_request, class: AllscriptsUnityClient::JSONUnityRequest

    skip_create
  end
end
