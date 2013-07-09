RSpec::Matchers.define :be_trained_for_project do |expected_project|
  match do |actual|
    actual.project == expected_project && actual.trained && expected_project.rules.exists?(url: entry.url)
  end
end

RSpec::Matchers.define :be_destroyed do
  match do |actual|
    actual.class.exists?(actual.id) == false
  end
end