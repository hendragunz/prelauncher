source 'https://rubygems.org'
ruby '2.1.2'

# cores
gem 'rails', '3.2.21'
gem 'pg'
gem 'activeadmin'
gem 'devise', '~> 3.4.1'
gem 'omniauth-facebook'
gem 'counter_culture', '~> 0.1.23'

# views / js / css
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 3.3.4'
end


group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'thin'
end

group :development do
  gem 'quiet_assets'
end

group :production do
  gem 'rails_12factor'
end

gem 'delayed_job_active_record'
gem 'unicorn'
gem 'exception_notification'