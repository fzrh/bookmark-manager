ENV['RACK_ENV'] = 'test' # because we need to know what database to work with

# this needs to be after ENV["RACK_ENV"] = 'test'
# because the server needs to know
# what environment it's running it: test or development.
# the environment determines what database to use.

require './server'
require 'database_cleaner'
require 'capybara/rspec'

Capybara.app = Sinatra::Application

RSpec.configure do |config|

config.before(:suite) do
DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)
end

config.before(:each) do
DatabaseCleaner.start
end

config.after(:each) do
DatabaseCleaner.clean
end

end