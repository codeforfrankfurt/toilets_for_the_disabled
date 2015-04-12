require 'rubygems'
require 'mechanize'

require_relative 'lib/result_page'
require_relative 'lib/toilet_details'


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