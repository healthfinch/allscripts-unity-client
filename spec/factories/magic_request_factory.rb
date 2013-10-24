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
    action Faker::Name.name
    appname Faker::Name.name
    userid Faker::Name.name
    patientid Faker::Name.name
    token Faker::Name.name
    parameter1 Faker::Name.name
    parameter2 Faker::Name.name
    parameter3 Faker::Name.name
    parameter4 Faker::Name.name
    parameter5 Faker::Name.name
    parameter6 Faker::Name.name
    data Faker::Name.name
  end
end