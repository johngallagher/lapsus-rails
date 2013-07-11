# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    started_at "2013-07-01 18:23:47"
    finished_at "2013-07-01 18:23:47"
    project_id 1

    trait :document do
      url "/Users/John/Documents/WhyILoveCheese.md"
    end

    trait :parent do
      url "/Users/John/Documents"
    end

    trait :grandparent do
      url "/Users/John"
    end

    trait :folder do
      url "/Users/John"
    end

    trait :child do
      url "/Users/John/Documents"
    end

    trait :grandchild do
      url "/Users/John/Documents/WhyILoveCheese.md"
    end
  end
end
