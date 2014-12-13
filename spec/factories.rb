FactoryGirl.define do
  factory :user do |user|
    user.email                  "user@example.com"
    user.password               "password"
    user.password_confirmation  "password"
  end

  factory :container do
    name "Code"
    path "/Users/John/Code"
    user_id User.first ? User.first.id : nil
  end

  factory :project do
    name "Code"
    path "/Users/John/Code/rails"
    user_id User.first ? User.first.id : nil
  end

  factory :entry do
    sequence(:started_at, 10) { |seconds|  "2013-07-01 18:23:#{seconds}" }
    sequence(:finished_at, 11) { |seconds|  "2013-07-01 18:23:#{seconds}" }
    path "/Users/John/Code/rails/Gemfile"
    user_id User.first ? User.first.id : nil
  end
end
