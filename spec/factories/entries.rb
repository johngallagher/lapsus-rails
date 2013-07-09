# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    started_at "2013-07-01 18:23:47"
    finished_at "2013-07-01 18:23:47"
    project_id 1

    trait :document do
      url "file://Users/John/Documents/WhyILoveCheese.md"
    end

    trait :folder do
      url "file://Users/John/Documents/"
    end
  end
end
