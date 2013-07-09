# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rule do
    project_id 1
    
    trait :document do
      url "file://Users/John/Documents/WhyILoveCheese.md"
    end

    trait :folder do
      url "file://Users/John/Documents/"
    end
  end
end
