source 'http://rubygems.org'

gem 'rails', '3.0.7'

gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'maruku' # for haml markdown
gem 'haml'
gem 'haml-rails'
gem 'devise'
gem 'formtastic'
gem "cancan"

group :test do
  gem 'webrat'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'rcov'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'autotest'
end

group :development, :production do
  gem 'pivotal-tracker' # make sure it is not under test at all
end


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
