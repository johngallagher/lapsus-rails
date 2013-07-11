# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rule do
    project { create(:project)}
    
    trait :document do
      url { build(:entry, :document).url }
    end

    trait :parent do
      url { build(:entry, :parent).url }
    end

    trait :grandparent do
      url { build(:entry, :grandparent).url }
    end
  end
end
