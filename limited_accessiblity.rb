require 'rubygems'
require 'mechanize'

require_relative 'result_page'
require_relative 'toilet_details'


class LimitedAccessiblity < Mechanize
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

LimitedAccessiblity.new.process