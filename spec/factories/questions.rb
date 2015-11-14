FactoryGirl.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  factory :question do
    title 
		body "Question body"
  end

  factory :invalid_question, class: "Question" do
  	title nil
  	body nil
  end
end
