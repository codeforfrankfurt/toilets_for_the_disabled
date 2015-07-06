require 'mongo'

class ToiletDocs

  def initialize(toilet_details)
    @toilet_details = toilet_details

    client = ::Mongo::MongoClient.new('localhost', 27017)
    @collection = client.db('toilets_for_the_disabled').collection('toilets')
  end

  def save
    query = @toilet_details.basic_attributes
    puts @collection.update(query, {"$setOnInsert" => @toilet_details.to_hash}, {upsert: true})
  end

end
