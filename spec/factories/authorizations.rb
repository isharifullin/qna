FactoryGirl.define do
  factory :authorization do
    user
    provider 'provider_name'
    uid '123456789'  
  end
end
