# Toilets for the Disabled in Frankfurt

Currently there's a scraper, getting detailed data on over 1770 locations with accessible toilets.

That data is stored into a MongoDB database so make sure you have it installed.

The plan is to put that data into a dedicated mobile and web app and on openstreetmap.org.

Next/open steps:
* Pushing the data to OSM via their API
* App for spotting
* Web API  for accepting POIs spotted by the API

# Install

    You need Ruby

	gem install bundler

	# inside the project dir
	bundle install

# Scraper

	Run the scraper with
    
    	rake
    	
    or the following if you want the count for each key
    
    	SAVE_COUNT=true rake

# Server
	
	ruby server.rb