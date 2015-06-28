require_relative 'toilet_details'
require_relative 'toilet_docs'

class ResultPage
  def initialize(agent, page)
    @agent = agent
    @page = page
  end

  def scrape
    @page.links_with(href: /\?angebot/).each do |link|
      text = link.text.strip
      next unless text.length > 0

      begin
        @agent.transact do
          detail_page = @agent.click(link)

          addressblock = detail_page.at('.addressblock')
          name = addressblock.at('dl:first dd').text.strip
          address = addressblock.at('dl:nth-child(3) dd').xpath('text()').map(&:text)

          h3 = detail_page.at('h3.ergebnis span')
          next unless h3.text == "Toilette" # if there are no toilet details, we're not interested

          div = h3.ancestors('div').first

          toilet_details = ToiletDetails.new(name, address, div)

          puts toilet_details.to_hash.map { |k, v| "#{k}: #{v}" }

          doc = ToiletDocs.new(toilet_details)
          doc.save

        end
      rescue => e
        $stderr.puts "#{e.class}: #{e.message}"
      end
      puts
    end

    @page = @agent.click(next_results_link)
  end

  def has_next?
    !next_results_link.nil?
  end

  protected

    def next_results_link
      @page.link_with(href: /stadtfuehrer.html\?.*suche_dir=2.*(?<!\&L=\d)\Z/)
    end
end
