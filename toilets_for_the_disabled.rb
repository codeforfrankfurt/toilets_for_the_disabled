require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'])

require 'mechanize'

require_relative 'lib/result_page'


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

Geocoder.configure(:mapquest => {:open => true})
ToiletsForTheDisabled.new.process
