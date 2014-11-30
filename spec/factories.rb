FactoryGirl.define do

  factory :entry do
    started_at "2013-07-01 18:23:47"
    finished_at "2013-07-01 18:23:47"

    trait :rails_gemfile do
      url "/Users/John/Code/rails/Gemfile"
    end
  end

  factory :container do
    trait :code do
      name "Code"
      url "/Users/John/Code"
    end
  end
end
