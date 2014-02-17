source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'mysql2'
gem 'activeadmin', github: 'gregbell/active_admin'

group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'

	gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease.
# Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'
gem 'unicorn'
gem 'factory_girl_rails'
gem 'faker'
gem 'friendly_id'
gem 'carrierwave'
gem 'mini_magick'
gem 'rmagick', '2.13.2', git: 'http://github.com/rmagick/rmagick.git'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano-unicorn'
  gem 'rvm-capistrano', github: 'wayneeseguin/rvm-capistrano'
  gem 'capistrano-helpers'
end
group :development, :test do
  gem 'debugger'
  gem 'rspec-rails'
end
