FactoryGirl.define do
  factory :magic_request, :class => Hash do
    initialize_with { attributes }

    action nil
    appname nil
    userid nil
    patientid nil
    token nil
    parameter1 nil
    parameter2 nil
    parameter3 nil
    parameter4 nil
    parameter5 nil
    parameter6 nil
    data nil
  end

  factory :populated_magic_request, :parent => :magic_request do
    action ["GetServerInfo", "GetProviders"].sample
    appname Faker::Company.name
    userid ["jmedici", "lmccoy"].sample
    patientid Faker::Number.number(3)
    token SecureRandom.uuid
    parameter1 Faker::Internet.domain_word
    parameter2 Faker::Internet.domain_word
    parameter3 Faker::Internet.domain_word
    parameter4 Faker::Internet.domain_word
    parameter5 Faker::Internet.domain_word
    parameter6 Faker::Internet.domain_word
    data Faker::Internet.domain_word
  end
end