source 'https://rubygems.org'

# Multithreaded server best suited for Production environments
gem 'puma'
gem 'rack-timeout'
gem 'delayed_job_active_record' # delayed_job
gem "daemons"
gem 'newrelic_rpm'
gem 'rack-zippy' 				#serve compressed assets

gem 'stripe_event'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgresql as the database for Active Record
gem 'pg'


# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Static asset serving and logging on Heroku
gem 'rails_12factor', group: :production

ruby "2.1.1"

gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'

#Gravitar gem
gem 'gravtastic'

#Gem for calendar
gem "simple_calendar", "~> 1.1.0"
gem 'time_diff', '~> 0.3.0'

#Development gems
group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  #Better errors
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'capybara', '~> 2.1.0'
end


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'angularjs-rails'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 3.2'
gem 'bootstrap-sass', '~> 3.2.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
gem 'underscore-rails'
gem 'sprockets'

gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

#Push noitifications and cron jobs
gem 'pusher'
gem 'whenever', :require => false

gem 'mail_view', :git => 'https://github.com/basecamp/mail_view.git'

group :development do
  gem 'rails_best_practices'
  gem 'brakeman'
end




