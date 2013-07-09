RSpec::Matchers.define :be_trained_for_project do |expected_project|
  match do |actual|
    actual.project == expected_project && actual.trained && expected_project.rules.exists?(url: entry.url)
  end
end