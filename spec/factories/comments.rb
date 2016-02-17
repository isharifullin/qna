FactoryGirl.define do

  factory :comment do
    body 'My comment body'
    user
  end

  factory :invalid_comment, class: "Comment" do
    body nil
  end
end
