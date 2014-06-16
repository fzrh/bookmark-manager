env = ENV['RACK_ENV'] || "development"
# we're telling datamapper to use a postgres database on localhost. the name will be 'bookmark_manager_test' or 'bookmark_manager_development' depending on the environment
DataMapper.setup(:default, "postgress://localhost/bookmark_manager+#{env}")

require './lib/link' # this needs to be done after datamapper is initialised

# after declaring your models, you should finalise them
DataMapper.finalize

# however, the database tables don't exist yet. let's tell datamapper to create them
DataMapper.auto_upgrade!