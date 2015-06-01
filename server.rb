require 'sinatra'
require "json"
require 'mongo'

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
    "properties" => {
      "popupContent" => popup_content(doc)
    },
    "id" => doc['_id']
  }
end

def popup_content(doc)
  except = ['_id', 'name', 'street', 'place']
  result = doc.dup
  except.each do |field|
    result.delete field
  end
  doc['name'] << "\n\n" << result.inspect
end
