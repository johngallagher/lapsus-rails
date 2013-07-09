# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rule do
    url "file://Users/John/Documents/WhyILoveCheese.md"
    project_id 1
  end
end
