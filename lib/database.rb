require 'mongo'

class Database

  def initialize
    client = ::Mongo::MongoClient.new('localhost', 27017)
    @db = client.db('toilets_for_the_disabled')
  end

  def collection(name)
    @db.collection(name)
  end

end