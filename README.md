# Toilets for the Disabled in Frankfurt

Currently there's a scraper, getting detailed data on over 1770 locations with accessible toilets.

And a deployed web app on [tftd.herokuapp.com](https://tftd.herokuapp.com) that maps the data.

It uses a MongoDB database so make sure you have that installed if you want to work with the data.

The plan is to extend the project with a dedicated mobile app and to push the data into openstreetmap.org.

# Next/open steps:
* make the filters actually do something
* Pushing the data to OSM via their API
* App for spotting
* Web API  for accepting POIs spotted by the API

Currently the index.html gets its data from the deployed web app on [tftd.herokuapp.com](https://tftd
.herokuapp.com). This is so you can develop features right away without having to scrape and geocode to get
started.

The ruby scraper and server however are currently configured to use the local database.
See `lib/database.rb` to change that. If you want the map to show your local data as well
set the jsonURL variable in index.html to simply `spots` and it will get the data from
your local ruby webserver and MongoDB.

Deployment is handled via heroku, send me a pull request if you want me to deploy a feature or bugfix.

# Developing on the web app only

	cd website
	python -m SimpleHTTPServer 4567 # or any other local HTTP server, but only port 4567 is allowed per CORS
	# open http://localhost:4567 in your browser 

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