FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password               "password"
    password_confirmation  "password"
  end

  factory :container do
    name "Code"
    path "/Users/John/Code"
  end

  factory :project do
    name "Code"
    path "/Users/John/Code/rails"

    trait :none do
      preset true
      name   'None' 
      path   ''
    end
  end

  factory :entry do
    sequence(:started_at, 10) { |seconds|  "2013-07-01 18:23:#{seconds}" }
    sequence(:finished_at, 11) { |seconds|  "2013-07-01 18:23:#{seconds}" }

    before(:create) do |entry|
      if entry.user.nil?
        entry.user = User.first || create(:user)
      end

      if entry.project.nil?
        none = Project.none_for_user(entry.user)
        if none
          entry.project = none
        else
          entry.project = Project.create_none_for_user!(entry.user)
        end
      end
    end
  end
end
