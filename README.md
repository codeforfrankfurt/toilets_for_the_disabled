# Toilets for the Disabled in Frankfurt

Currently there's a scraper, getting detailed data on over 1770 locations with accessible toilets.

That data is stored into a MongoDB database so make sure you have it installed.

The plan is to put that data into a dedicated mobile and web app and on openstreetmap.org.

# Next/open steps:
* make the filters actually do something
* Pushing the data to OSM via their API
* App for spotting
* Web API  for accepting POIs spotted by the API

Currently the index.html gets its data from the deployed web app on [tftd.herokuapp.com](https://tftd.herokuapp.com).

The ruby scraper and server however are currently configured to use the local database.
See `lib/database.rb` to change that. If you want the map to show your local data as well
set the jsonURL variable in index.html to simply `spots` and it will get the data from
your local ruby webserver and MongoDB.

# Install (when you want to scrape or serve data locally)

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