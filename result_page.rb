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

          dl = detail_page.at('.addressblock dl:first')
          name = dl.at('dd').text.strip

          h3 = detail_page.at('h3.ergebnis span')
          next unless h3.text == "Toilette"

          div = h3.ancestors('div').first

          toilet_details = ToiletDetails.new(name, div)

          puts toilet_details.to_hash.map { |k, v| "#{k}: #{v}" }

        end
      rescue => e
        $stderr.puts "#{e.class}: #{e.message}"
      end
      puts
    end

    @page = @agent.click(@page.link_with(href: /stadtfuehrer.html\?.*suche_dir=2/))
  end

  def has_next?
    !@page.link_with(href: /stadtfuehrer.html\?.*suche_dir=2/).nil?
  end
end