require_relative 'database'
require 'geocoder'

Geocoder.configure(
  :lookup => :mapquest,
  :mapquest => {:open => true, :api_key => ENV['MAPQUEST_KEY']},
  :language => :de,

  # geocoding service request timeout, in seconds (default 3):
  :timeout => 5,

  # set default units to kilometers:
  :units => :km,
)

class ToiletDoc

  def initialize(toilet_details)
    @toilet_details = toilet_details
    @collection = self.class.get_collection
  end

  def self.all
    get_collection.find.to_a
  end

  def save
    query = @toilet_details.query
    puts @collection.update(query, {"$setOnInsert" => @toilet_details.to_hash}, {upsert: true})
    geocode
  end

  def geocode(doc = nil)
    query = @toilet_details.query
    doc = @collection.find_one(query) unless doc
    unless doc['location']
      result = Geocoder.search(doc['address'], params: {countrycodes: "de"}).first
      if result
        puts "geocoded:"
        puts @collection.update(query, {"$set" => location_fields(result)})
      end
    end
  end

  def self.get_collection
    Database.new.collection('toilets')
  end

  protected

    def location_fields(result_object)
      {
        "location" => {
          "lat" => result_object.latitude,
          "lng" => result_object.longitude,
          "burrough" => result_object.data['adminArea6'],
          "postal_code" => result_object.postal_code
        }
      }
    end
end
