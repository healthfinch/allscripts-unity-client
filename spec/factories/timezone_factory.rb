FactoryGirl.define do
  factory :timezone, class: AllscriptsUnityClient::Timezone do
    initialize_with { new(zone_identifier) }

    zone_identifier 'America/Phoenix'
  end
end