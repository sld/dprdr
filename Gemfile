source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.15'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'pg'
gem 'rolify'

gem 'jquery-rails'

gem 'capistrano', '~> 2.15'


group :production do
  gem 'therubyracer'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'quiet_assets'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end
