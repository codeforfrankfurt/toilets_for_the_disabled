require 'mongo'

class ToiletDocs

  def initialize(toilet_details)
    @toilet_details = toilet_details

    client = ::Mongo::MongoClient.new('localhost', 27017)
    @collection = client.db('toilets_for_the_disabled').collection('toilets')
  end

  def save
    query = @toilet_details.query
    puts @collection.update(query, {"$setOnInsert" => @toilet_details.to_hash}, {upsert: true})
    geocode
  end

  protected
  
    def geocode
      query = @toilet_details.query
      doc = @collection.find_one(query)
      unless doc['location']
        result = Geocoder.search(doc['address'], params: {countrycodes: "de"}).first
        if result
          puts "geocoded:"
          puts @collection.update(query, {"$set" => location_fields(result)})
        end
      end
    end

    def location_fields(result_object)
      {
        "location" => {
          "lat" => result_object.latitude,
          "lng" => result_object.longitude,
          "burrough" => result_object.address_components_of_type(:sublocality),
          "postal_code" => result_object.postal_code
        }
      }
    end
end
