source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'jquery-rails'
gem "mysql2", ">= 0.3.11"
gem "simple_form", ">= 2.1.0"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem "quiet_assets", ">= 1.0.2"
  gem 'better_errors', '>= 0.6.0'
  gem 'binding_of_caller', '>= 0.7.1', :platforms => [:mri_19, :rbx]
end

group :development, :test do
  gem 'pry-rails'
  gem 'thin', '>= 1.5.0'
  gem 'rspec-given'
  gem 'rspec-rails', '>= 2.12.2'
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'awesome_print', '~> 1.1.0'
end

group :sandbox, :staging, :production do
  gem 'ey_config'
  gem 'sendgrid'
end

group :test do
  gem 'database_cleaner', '>= 0.9.1'
  gem 'email_spec', '>= 1.4.0'
  gem 'shoulda-matchers'
end

group :production do
  gem 'unicorn', '>= 4.3.1'
  gem "newrelic_rpm", "~> 3.5.5.38"
end
