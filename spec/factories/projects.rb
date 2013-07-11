# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "Project"

    trait :video do
      name "Video"
    end

    trait :newsroom do
      name "Newsroom"
    end
  end
end
