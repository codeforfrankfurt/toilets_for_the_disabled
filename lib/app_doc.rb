require_relative 'database'
require_relative 'toilet_doc'
require_relative 'toilet_details'

class AppDoc

  def self.get_settings
    get_collection.find_one(settings_criteria, fields: {counts: 0})
  end

  def self.save_all_fields(options = {})
    filters = {}
    counts = Hash.new(0)

    doc = get_settings
    if doc && doc['filters']
      filters = doc['filters']
    end

    docs = ToiletDoc.all
    docs.each do |doc|
      keys = doc.keys - ignored_keys
      keys_hash = keys.inject({}) {|result, key| result.merge(key => false)}
      filters = keys_hash.merge(filters)
      keys.each do |key|
        counts[key] += 1
      end
    end

    require 'pp'
    pp filters

    update_doc = {filters: filters}
    if options[:save_count]
      update_doc[:counts] = Hash[counts.sort_by {|key, count| count}]
    end
    puts get_collection.update(settings_criteria, {"$set" => update_doc}, upsert: true)
  end

  protected

    def self.settings_criteria
      {_id: 'settings'}
    end

    def self.ignored_keys
      ['_id'] + ToiletDetails.basic_keys
    end

    def self.get_collection
      Database.new.collection('app_data')
    end

end
