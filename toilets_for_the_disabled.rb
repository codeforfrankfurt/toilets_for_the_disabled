require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'])

require 'mechanize'
require_relative 'lib/result_page'
require_relative 'lib/app_doc'


class ToiletsForTheDisabled < Mechanize
  def process
    agent = self
    get('http://frankfurt-handicap.de/stadtfuehrer.html?suche_action=los&bar_search=9') do |page|
      result_page = ResultPage.new(agent, page)

      while result_page.has_next?
        result_page.scrape
      end

    end
  end
end

ToiletsForTheDisabled.new.process

save_count = ENV['SAVE_COUNT'] == "true"
AppDoc.save_all_fields(save_count: save_count)
