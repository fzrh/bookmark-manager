# this class corresponds to a table in the database
# we can use it to manipulate the data

class Link
	# this makes the instances of this class Datamapper resources
	include DataMapper::Resource

	has n, :tags, :through => Resource

	# this block describes what resources our model will have
	property :id, 		Serial # serial means that it will be auto-inremented for every second
	property :title, 	String
	property :url, 		String

end