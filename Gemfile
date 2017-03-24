source 'http://rubygems.org'

ruby '2.3.0'

gemspec

gem 'rake'
gem 'bunny' # for producing/consuming evets from RabbitMQ

group :development do
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'pry-rescue'
end

group :test do
  gem 'rspec'
  gem 'rspec-mocks'
end
