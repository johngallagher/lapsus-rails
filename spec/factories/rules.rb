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

    trait :folder do
      url { build(:entry, :folder).url }
    end

    trait :child do
      url { build(:entry, :child).url }
    end

    trait :grandchild do
      url { build(:entry, :grandchild).url }
    end
  end
end
