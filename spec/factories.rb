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
    sequence(:started_at, 10) { |seconds|  "2013-07-01 18:23:#{seconds}" }
    sequence(:finished_at, 11) { |seconds|  "2013-07-01 18:23:#{seconds}" }
    url "file:///Users/John/Code/rails/Gemfile"
  end
end
