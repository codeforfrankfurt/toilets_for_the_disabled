require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'])

task :default do
  require_relative 'toilets_for_the_disabled'
end

task :geocode do
  require_relative 'lib/toilet_doc'
  require_relative 'lib/toilet_details'
  docs = ToiletDoc.all
  docs.each do |doc|
    doc
    toilet_details = ToiletDetails.new(doc)
    ToiletDoc.new(toilet_details).geocode(doc)
  end
end
