source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.15'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'pg'
gem 'rolify'

gem 'dropbox-sdk'

gem 'jquery-rails'

gem 'capistrano', '~> 2.15'

gem 'carrierwave'

gem 'honeybadger'

gem 'pdf-reader'
gem 'rmagick'

gem 'state_machine'

gem 'sidekiq'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-dropbox2'

gem 'jquery-fileupload-rails'

group :assets, :production do
  gem 'uglifier', '>= 1.0.3'
  gem "therubyracer", ">= 0.10.2", :platform => :ruby
  gem 'turbo-sprockets-rails3'
end


group :production do
  gem "passenger"
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
  gem 'mocha', :require => false
  gem 'test_after_commit'
end
