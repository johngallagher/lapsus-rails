FactoryGirl.define do
  factory :container do
    name "Code"
    url "file:///Users/John/Code"
  end

  factory :project do
    name "Code"
    url "file:///Users/John/Code/rails"
  end

  factory :entry do
    started_at "2013-07-01 18:23:47"
    finished_at "2013-07-01 18:23:47"
    url "file:///Users/John/Code/rails/Gemfile"
  end
end
