require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'])

require 'sinatra'
require 'mongo'
require 'json'

set :public_folder, 'website'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/spots' do
  client = ::Mongo::MongoClient.new('localhost', 27017)
  @collection = client.db('toilets_for_the_disabled').collection('toilets')

  json_body = {
    "type" => "FeatureCollection",
    "features" => []
  }

  docs = @collection.find.to_a
  docs.each do |doc|
    json_body["features"] << spot(doc)
  end

  content_type :json
  json_body.to_json
end

def spot(doc)
  {
    "geometry" => {
      "type" => "Point",
      "coordinates" => [doc['location'].last, doc['location'].first]
    },
    "type" => "Feature",
    "properties" => geojson_properties(doc),
    "id" => doc['_id']
  }
end

def geojson_properties(doc)
  except = ['_id', 'location', 'address']
  result = doc.dup
  except.each do |field|
    result.delete field
  end
  result
end
