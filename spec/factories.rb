# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  trait :home_folder do
    url "/Users/John"
  end

  trait :pictures_folder do
    url "/Users/John/Pictures"
  end

  trait :documents_folder do
    url "/Users/John/Documents"
  end

  trait :cheese_document do
    url "/Users/John/Documents/Cheese.md"
  end

  factory :entry do
    started_at "2013-07-01 18:23:47"
    finished_at "2013-07-01 18:23:47"
    project_id 1

    trait :trained do
      trained true
    end

    trait :untrained do
      trained false
    end
  end

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
