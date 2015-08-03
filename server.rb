require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'])

require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative 'lib/app_doc'
require_relative 'lib/toilet_doc'

set :public_folder, 'website'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/spots' do
  json_body = {
    "type" => "FeatureCollection",
    "features" => [],
    "properties" => AppDoc.get_settings['filters']
  }

  docs = ToiletDoc.all
  docs.each do |doc|
    spot = spot_to_feature(doc)
    json_body["features"] << spot if spot
  end

  cross_origin :allow_origin => 'http://localhost:4567'

  content_type :json
  json_body.to_json
end

def spot_to_feature(doc)
  return nil unless doc['location']
  {
    "geometry" => {
      "type" => "Point",
      "coordinates" => [doc['location']['lng'], doc['location']['lat']]
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
