FactoryGirl.define do
  factory :client, class: AllscriptsUnityClient::Client do
    initialize_with { new(client_driver) }

    client_driver { build(:client_driver) }
  end
end
