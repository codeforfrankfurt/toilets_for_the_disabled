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
      keys_hash = keys.inject({}) {|result, key| result.merge(key => nil)}
      filters = keys_hash.merge(filters)
      keys.each do |key|
        counts[key] += 1
      end
    end

    activate_filters(filters, counts)

    require 'pp'
    pp filters

    update_doc = {filters: filters}
    if options[:save_count]
      update_doc[:counts] = Hash[counts.sort_by {|key, count| count}]
    end
    puts get_collection.update(settings_criteria, {"$set" => update_doc}, upsert: true)
  end

  protected

    def self.activate_filters(filters, counts)
      filters.each do |key, value|
        filters[key] = value || (counts[key] >= 100 && key != 'location')
        if filters[key]
          distinct_values = ToiletDoc.get_collection.distinct(key)
          update_doc = {key => distinct_values}
          get_collection.update(values_criteria, {"$set" => update_doc}, upsert: true)
          filters[key] = control_type(distinct_values)
        else
          filters.delete(key)
        end
      end
    end

    def self.control_type(values)
      if values.all? {|value| ["Ja", "Nein"].include?(value)}
        "checkbox"
      elsif values.all? {|value| value.to_i != 0}
        "number"
      else
        "select"
      end
    end

    def self.settings_criteria
      {_id: 'settings'}
    end

    def self.values_criteria
      {_id: 'values'}
    end

    def self.ignored_keys
      ['_id'] + ToiletDetails.basic_keys.map(&:to_s)
    end

    def self.get_collection
      Database.new.collection('app_data')
    end

end
