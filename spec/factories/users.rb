FactoryGirl.define do
  sequence :email do |n|
 		"user#{n}@test.com"
  end

  factory :user do
  	email
  	password '12345678'
    password_confirmation '12345678'
  end

  factory :invalid_user, class: "User" do
    email ''
    password ''
    password_confirmation ''
  end
end
