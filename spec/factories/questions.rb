FactoryGirl.define do
  sequence :title do |n|
    "MyQuestion#{n}"
   end

  factory :question do
    title
		body 'MyQuestionBody'
    user
  end

  factory :invalid_question, class: "Question" do
  	title nil
  	body nil
  end
end
