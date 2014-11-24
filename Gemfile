source 'https://rubygems.org'

gem 'rails', '4.1.7'
gem "mysql2", ">= 0.3.11"

group :development, :test do
  gem 'pry-rails'
  gem 'thin', '>= 1.5.0'
  gem 'rspec-given'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'awesome_print', '~> 1.1.0'
end

group :sandbox, :staging, :production do
  gem 'ey_config'
  gem 'sendgrid'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

