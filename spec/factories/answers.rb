FactoryGirl.define do

  sequence :body do |n|
    "MyAnswer#{n}"
   end
  
  factory :answer do
    body  
    user
  end

  factory :invalid_answer, class: "Answer" do
  	body nil
  end
end
